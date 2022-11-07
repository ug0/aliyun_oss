defmodule Aliyun.Oss.Client do
  @moduledoc """
  Internal module
  """

  alias Aliyun.Oss.Client.{Request, Response, Error}

  def request(init_req) do
    case init_req |> Request.build_signed() |> do_request do
      {:ok, %HTTPoison.Response{body: body, status_code: status_code, headers: headers}}
      when status_code in 200..299 ->
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

  defp do_request(req = %Request{verb: "POST"}) do
    HTTPoison.post(
      Request.query_url(req),
      req.body,
      req.headers
    )
  end

  defp do_request(req = %Request{verb: "PUT"}) do
    HTTPoison.put(
      Request.query_url(req),
      req.body,
      req.headers
    )
  end

  defp do_request(req = %Request{verb: "DELETE"}) do
    HTTPoison.delete(
      Request.query_url(req),
      req.headers
    )
  end
end
