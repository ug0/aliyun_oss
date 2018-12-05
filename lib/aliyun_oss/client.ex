defmodule Aliyun.Oss.Client do
  alias Aliyun.Oss.Client.{Request, Response, Error}

  def request(init_req) do
    case init_req |> Request.build_signed() |> do_request do
      {:ok, %HTTPoison.Response{body: body, status_code: 200, headers: headers}} ->
        {:ok, Response.parse(body, headers)}

      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        {:error, Error.parse(%Error{body: body, status_code: status_code})}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
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
