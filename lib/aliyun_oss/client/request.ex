defmodule Aliyun.Oss.Client.Request do
  @moduledoc """
  Internal module
  """
  alias Aliyun.Oss.ConfigAlt, as: Config

  @enforce_keys [:host, :path, :resource]
  defstruct verb: "GET",
            host: nil,
            path: nil,
            scheme: "https",
            resource: nil,
            query_params: %{},
            sub_resources: %{},
            body: "",
            headers: %{},
            expires: nil

  @default_content_type "application/octet-stream"

  def build(fields) do
    __MODULE__
    |> struct!(fields)
    |> ensure_essential_headers()
  end

  def build_signed(%Config{} = config, fields) do
    %{access_key_id: access_key_id, access_key_secret: access_key_secret} = config

    build(fields)
    |> set_authorization_header(access_key_id, access_key_secret)
  end

  def to_url(%__MODULE__{} = req) do
    URI.to_string(%URI{
      scheme: req.scheme,
      host: req.host,
      path: encode_path(req.path),
      query: Map.merge(req.query_params, req.sub_resources) |> URI.encode_query()
    })
  end

  defp encode_path(path), do: String.replace(path, "+", "%2B")

  def to_signed_url(%Config{} = config, %__MODULE__{} = req) do
    %{access_key_id: access_key_id, access_key_secret: access_key_secret} = config
    signature = gen_signature(req, access_key_secret)

    req
    |> Map.update!(:query_params, fn params ->
      Map.merge(params, %{
        "Expires" => req.expires,
        "OSSAccessKeyId" => access_key_id,
        "Signature" => signature
      })
    end)
    |> to_url()
  end

  defp ensure_essential_headers(%__MODULE__{} = req) do
    headers =
      req.headers
      |> Map.put_new("Host", req.host)
      |> Map.put_new_lazy("Content-Type", fn -> parse_content_type(req) end)
      |> Map.put_new_lazy("Content-MD5", fn -> calc_content_md5(req) end)
      |> Map.put_new_lazy("Content-Length", fn -> byte_size(req.body) end)
      |> Map.put_new_lazy("Date", fn -> Aliyun.Util.Time.gmt_now() end)

    Map.put(req, :headers, headers)
  end

  defp set_authorization_header(%__MODULE__{} = req, access_key_id, access_key_secret) do
    update_in(req.headers["Authorization"], fn _ ->
      "OSS " <> access_key_id <> ":" <> gen_signature(req, access_key_secret)
    end)
  end

  defp canonicalize_oss_headers(%{headers: headers}) do
    headers
    |> Stream.filter(&is_oss_header?/1)
    |> Stream.map(&encode_header/1)
    |> Enum.join("\n")
    |> case do
      "" -> ""
      str -> str <> "\n"
    end
  end

  defp is_oss_header?({h, _}) do
    Regex.match?(~r/^x-oss-/i, to_string(h))
  end

  defp encode_header({h, v}) do
    (h |> to_string() |> String.downcase()) <> ":" <> to_string(v)
  end

  defp canonicalize_query_params(%{query_params: query_params}) do
    query_params
    |> Stream.map(fn {k, v} -> "#{k}:#{v}\n" end)
    |> Enum.join()
  end

  defp canonicalize_resource(%{resource: resource, sub_resources: nil}), do: resource

  defp canonicalize_resource(%{resource: resource, sub_resources: sub_resources}) do
    sub_resources
    |> Stream.map(fn
      {k, nil} -> k
      {k, v} -> "#{k}=#{v}"
    end)
    |> Enum.join("&")
    |> case do
      "" -> resource
      query_string -> resource <> "?" <> query_string
    end
  end

  defp parse_content_type(%{resource: resource}) do
    case Path.extname(resource) do
      "." <> name -> MIME.type(name)
      _ -> @default_content_type
    end
  end

  defp gen_signature(%__MODULE__{} = req, secret) do
    req
    |> string_to_sign()
    |> Aliyun.Util.Sign.sign(secret)
  end

  defp string_to_sign(%__MODULE__{scheme: "rtmp"} = req) do
    expires_time(req) <>
      "\n" <>
      canonicalize_query_params(req) <> canonicalize_resource(req)
  end

  defp string_to_sign(%__MODULE__{} = req) do
    req.verb <>
      "\n" <>
      header_content_md5(req) <>
      "\n" <>
      header_content_type(req) <>
      "\n" <>
      expires_time(req) <>
      "\n" <>
      canonicalize_oss_headers(req) <> canonicalize_resource(req)
  end

  defp expires_time(%{expires: expires} = req), do: (expires || header_date(req)) |> to_string()

  defp header_content_md5(%{headers: %{"Content-MD5" => md5}}), do: md5
  defp header_content_type(%{headers: %{"Content-Type" => content_type}}), do: content_type
  defp header_date(%{headers: %{"Date" => date}}), do: date

  defp calc_content_md5(%{body: ""}), do: ""

  defp calc_content_md5(%{body: body}) do
    :crypto.hash(:md5, body) |> Base.encode64()
  end
end
