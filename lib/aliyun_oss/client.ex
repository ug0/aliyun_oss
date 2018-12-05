defmodule Aliyun.Oss.Client do
  alias Aliyun.Oss.Client.{Request, Response}

  def request(init_req) do
    case init_req |> Request.build_signed() |> do_request do
      {:ok, %HTTPoison.Response{body: body, status_code: 200, headers: headers}} ->
        {:ok, Response.parse(body, headers)}

      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        {:error, {:oss_error, status_code, Response.parse_error(body)}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, {:http_error, reason}}
    end
  end

  defp do_request(req = %Request{verb: "GET"}) do
    HTTPoison.get(
      Request.query_url(req),
      req.headers
    )
  end

  defp do_request(req = %Request{verb: "HEAD"}) do
    HTTPoison.head(
      Request.query_url(req),
      req.headers
    )
  end
end
