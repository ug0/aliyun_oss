defmodule Aliyun.Oss.Client do
  @moduledoc """
  Internal module
  """

  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Request, Response, Error}

  def request(%Config{} = config, init_req) when is_map(init_req) do
    type = Map.pop(init_req.headers, "Content-Type", nil)

    Request.build_signed(config, init_req)
    |> do_request()
    |> case do
      {:ok, %HTTPoison.Response{body: body, status_code: status_code, headers: headers}}
      when status_code in 200..299 ->
        headers =
          if is_nil(type) do
            headers
          else
            Enum.map(headers, fn
              {"Content-Type", _} -> {"Content-Type", type}
              other -> other
            end)
          end

        {:ok, Response.parse(body, headers)}

      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        {:error, Error.parse(%Error{body: body, status_code: status_code})}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp do_request(req = %Request{verb: "GET"}) do
    HTTPoison.get(
      Request.to_url(req),
      req.headers
    )
  end

  defp do_request(req = %Request{verb: "HEAD"}) do
    HTTPoison.head(
      Request.to_url(req),
      req.headers
    )
  end

  defp do_request(req = %Request{verb: "POST"}) do
    HTTPoison.post(
      Request.to_url(req),
      req.body,
      req.headers
    )
  end

  defp do_request(req = %Request{verb: "PUT"}) do
    HTTPoison.put(
      Request.to_url(req),
      req.body,
      req.headers
    )
  end

  defp do_request(req = %Request{verb: "DELETE"}) do
    HTTPoison.delete(
      Request.to_url(req),
      req.headers
    )
  end
end
