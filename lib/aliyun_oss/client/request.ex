defmodule Aliyun.Oss.Client.Request do
  @moduledoc """
  Internal module
  """
  alias Aliyun.Oss.{Config, Sign}
  alias Aliyun.Util.Encoder

  @hashed_request_header "x-oss-content-sha256"
  @default_payload_hash "UNSIGNED-PAYLOAD"
  @algorithm "OSS4-HMAC-SHA256"

  @enforce_keys [:config, :req]
  defstruct [:config, :req, :bucket, :object]

  def build!(%Config{} = config, method, bucket, object, headers, query_params, body \\ nil) do
    %__MODULE__{
      config: config,
      req:
        Req.new(
          method: method,
          url: build_url(config, bucket, object),
          params: query_params,
          headers: headers,
          body: body
        ),
      bucket: bucket,
      object: object
    }
  end

  def sign_header(%__MODULE__{} = request) do
    request
    |> ensure_necessary_headers()
    |> set_authorization_header()
  end

  def sign_url(%__MODULE__{} = request, expires_in_seconds \\ 3600) do
    request
    |> put_sign_query_params(expires_in_seconds)
    |> append_signature_param()
  end

  def request(%__MODULE__{req: req}) do
    Req.request(req)
  end

  def to_url(%__MODULE__{req: req}) do
    Req.Steps.put_params(req).url |> URI.to_string()
  end

  defp build_url(%Config{endpoint: endpoint}, nil, nil) do
    "https://#{endpoint}/"
  end

  defp build_url(%Config{endpoint: endpoint}, bucket, nil) do
    "https://#{bucket}.#{endpoint}/"
  end

  defp build_url(%Config{endpoint: endpoint}, bucket, object) do
    "https://#{bucket}.#{endpoint}/#{object}"
  end

  defp append_signature_param(%__MODULE__{} = request) do
    request
    |> put_param("x-oss-signature", calc_signature(request))
  end

  defp put_sign_query_params(%__MODULE__{} = request, expires_in_seconds) do
    request
    |> put_param("x-oss-signature-version", @algorithm)
    |> put_param("x-oss-date", gen_timestamp())
    |> put_param("x-oss-expires", expires_in_seconds)
    |> put_credential_param()
    |> maybe_put_additional_headers_param()
    |> maybe_put_sts_security_token_param()
  end

  defp put_credential_param(%__MODULE__{} = request) do
    put_param(request, "x-oss-credential", get_credential(request))
  end

  defp maybe_put_additional_headers_param(%__MODULE__{req: req} = request) do
    case additional_headers(req) do
      "" ->
        request

      headers ->
        put_param(request, "x-oss-additional-headers", headers)
    end

    request
  end

  defp maybe_set_sts_security_token(%__MODULE__{config: config} = request, set_fun) do
    case config do
      %Config{security_token: token} when is_binary(token) ->
        set_fun.(request, token)

      _ ->
        request
    end
  end

  defp maybe_put_sts_security_token_param(%__MODULE__{} = request) do
    maybe_set_sts_security_token(request, &put_param(&1, "x-oss-security-token", &2))
  end

  defp maybe_put_sts_security_token_header(%__MODULE__{} = request) do
    maybe_set_sts_security_token(request, &put_header(&1, "x-oss-security-token", &2))
  end

  defp hashed_request_payload(%__MODULE__{} = request) do
    get_header(request, @hashed_request_header) || @default_payload_hash
  end

  defp hash_digest(nil) do
    hash_digest("")
  end

  defp hash_digest(data) do
    :crypto.hash(:sha256, data) |> Base.encode16(case: :lower)
  end

  defp set_authorization_header(%__MODULE__{} = request) do
    put_header(request, "authorization", calc_authorization_header(request))
  end

  defp ensure_necessary_headers(%__MODULE__{} = request) do
    request
    |> put_new_header("x-oss-date", gen_timestamp())
    |> maybe_put_sts_security_token_header()
    |> put_new_header("content-type", parse_content_type(request))
    |> put_new_header(@hashed_request_header, @default_payload_hash)
  end

  defp gen_timestamp() do
    DateTime.utc_now(:second)
    |> DateTime.to_iso8601(:basic)
  end

  defp parse_content_type(%__MODULE__{req: req}) do
    with %URI{path: path} <- req.url,
         "." <> ext <- Path.extname(path) do
      MIME.type(ext)
    else
      _ -> "application/octet-stream"
    end
  end

  defp get_param(%__MODULE__{req: req}, key) do
    case Req.Request.get_option(req, :params, %{}) do
      %{^key => value} -> value
      _ -> nil
    end
  end

  defp put_param(%__MODULE__{req: req} = request, key, value) do
    new_params = req |> Req.Request.get_option(:params, %{}) |> Map.put(key, value)

    %{request | req: Req.Request.put_option(req, :params, new_params)}
  end

  def get_header(%__MODULE__{req: req}, key) do
    case Req.Request.get_header(req, key) do
      [header] -> header
      [] -> nil
    end
  end

  defp put_header(%__MODULE__{req: req} = request, key, value) do
    %{request | req: Req.Request.put_header(req, key, value)}
  end

  defp put_new_header(%__MODULE__{req: req} = request, key, value) do
    %{request | req: Req.Request.put_new_header(req, key, value)}
  end

  def calc_authorization_header(%__MODULE__{req: req} = request) do
    case additional_headers(req) do
      "" ->
        "#{@algorithm} Credential=#{get_credential(request)},Signature=#{calc_signature(request)}"

      headers ->
        "#{@algorithm} Credential=#{get_credential(request)},AdditionalHeaders=#{headers},Signature=#{calc_signature(request)}"
    end
  end

  defp get_credential(%__MODULE__{config: config} = request) do
    config.access_key_id <> "/" <> get_scope(request)
  end

  defp calc_signature(%__MODULE__{} = request) do
    request
    |> string_to_sign()
    |> Sign.sign(get_signing_key(request))
  end

  defp string_to_sign(%__MODULE__{} = request) do
    @algorithm <>
      "\n" <>
      get_timestamp(request) <>
      "\n" <> get_scope(request) <> "\n" <> hash_canonical_request(request)
  end

  defp get_signing_key(%__MODULE__{config: config} = request) do
    Sign.get_signing_key(config, get_date(request))
  end

  defp get_date(%__MODULE__{} = request) do
    [date, _] =
      request
      |> get_timestamp()
      |> String.split("T", parts: 2)

    date
  end

  defp get_timestamp(%__MODULE__{} = request) do
    get_header(request, "x-oss-date") || get_param(request, "x-oss-date")
  end

  defp get_scope(%__MODULE__{config: config} = request) do
    [get_date(request), config.region, "oss", "aliyun_v4_request"] |> Enum.join("/")
  end

  defp hash_canonical_request(%__MODULE__{} = request) do
    request
    |> canonical_request()
    |> hash_digest()
  end

  defp canonical_request(%__MODULE__{req: req} = request) do
    method_string(req) <>
      "\n" <>
      canonical_uri(request) <>
      "\n" <>
      canonical_query_string(req) <>
      "\n" <>
      canonical_headers(req) <>
      "\n" <>
      additional_headers(req) <>
      "\n" <>
      hashed_request_payload(request)
  end

  defp method_string(%Req.Request{} = req), do: req.method |> to_string() |> String.upcase()

  defp canonical_uri(%__MODULE__{bucket: bucket, object: object}) do
    canonical_uri(bucket, object)
  end

  defp canonical_uri(nil, nil) do
    Encoder.encode_uri("/")
  end

  defp canonical_uri(bucket, nil) do
    Encoder.encode_uri("/#{bucket}/")
  end

  defp canonical_uri(bucket, object) do
    Encoder.encode_uri("/" <> Path.join(bucket, object))
  end

  defp canonical_query_string(%Req.Request{} = req) do
    req
    |> Req.Request.fetch_option!(:params)
    |> Encoder.encode_params(strict_nil: true)
  end

  defp canonical_headers(%Req.Request{} = req) do
    req
    |> sort_and_filter_headers(&is_canonical_header?/1)
    |> Stream.map(fn {k, v} -> "#{k}:#{String.trim(v)}\n" end)
    |> Enum.join()
  end

  defp additional_headers(%Req.Request{} = req) do
    req
    |> sort_and_filter_headers(&is_additional_header?/1)
    |> Stream.map(fn {k, _} -> k end)
    |> Enum.join(";")
  end

  defp sort_and_filter_headers(%Req.Request{} = req, filter_fun) do
    req.headers
    |> Stream.map(fn {k, [v]} -> {String.downcase(k), v} end)
    |> Stream.filter(filter_fun)
    |> Enum.sort_by(fn {k, _} -> k end)
  end

  defp is_canonical_header?({"authorization", _}), do: false
  defp is_canonical_header?({_, _}), do: true

  defp is_additional_header?({"x-oss-" <> _, _}), do: false
  defp is_additional_header?({"content-type", _}), do: false
  defp is_additional_header?({"content-md5" <> _, _}), do: false
  defp is_additional_header?({"authorization" <> _, _}), do: false
  defp is_additional_header?({_, _}), do: true
end
