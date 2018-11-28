defmodule Aliyun.Oss.Client do
  alias Aliyun.Oss.Client.{Request, Error}

  def request(init_req) do
    signed_request = Request.build_signed(init_req)
    case HTTPoison.get(
           Request.query_url(signed_request),
           signed_request.headers
         ) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        {:error, {:oss_error, status_code, Error.parse_xml!(body)}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, {:http_error, reason}}
    end
  end
end
