defmodule Aliyun.Oss.Client.Request do
  import Aliyun.Oss.Config, only: [access_key_id: 0, access_key_secret: 0]

  @enforce_keys [:host, :path, :resource]
  defstruct verb: "GET",
            host: nil,
            path: nil,
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

  def build_signed(fields) do
    build(fields)
    |> set_authorization_header()
  end

  def gen_signature(%__MODULE__{} = req) do
    req
    |> string_to_sign()
    |> Aliyun.Util.Sign.sign(access_key_secret())
  end

  def query_url(%__MODULE__{} = req) do
    URI.to_string(%URI{
      scheme: "https",
      host: req.host,
      path: req.path,
      query: Map.merge(req.query_params, req.sub_resources) |> URI.encode_query()
    })
  end

  def signed_query_url(%__MODULE__{} = req) do
    req
    |> Map.update!(:query_params, fn params ->
      Map.merge(params, %{
        "Expires" => req.expires,
        "OSSAccessKeyId" => access_key_id(),
        "Signature" => gen_signature(req)
      })
    end)
    |> query_url()
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

  defp set_authorization_header(%__MODULE__{} = req) do
    update_in(req.headers["Authorization"], fn _ -> "OSS " <> access_key_id() <> ":" <> gen_signature(req) end)
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

  defp canonicalize_resource(%{resource: resource, sub_resources: nil}), do: resource
  defp canonicalize_resource(%{resource: resource, sub_resources: sub_resources}) do
    sub_resources
    |> Stream.map(&encode_param/1)
    |> Enum.join("&")
    |> case do
      "" -> resource
      query_string -> resource <> "?" <> query_string
    end
  end

  defp encode_param({k, nil}), do: k
  defp encode_param({k, v}), do: "#{k}=#{v}"

  defp parse_content_type(%{resource: resource}) do
    case Path.extname(resource) do
      "." <> name -> MIME.type(name)
      _ -> @default_content_type
    end
  end

  defp string_to_sign(%__MODULE__{} = req) do
    req.verb <> "\n" <>
    header_content_md5(req) <> "\n" <>
    header_content_type(req) <> "\n" <>
    expires_time(req) <> "\n" <>
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
