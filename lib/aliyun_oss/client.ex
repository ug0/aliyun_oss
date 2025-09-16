defmodule Aliyun.Oss.Client do
  @moduledoc """
  Internal module
  """

  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Request, Response, Error}

  def request(%Config{} = config, method, bucket, object, query_params, headers, body \\ nil) do
    config
    |> Request.build!(method, bucket, object, query_params, headers, body)
    |> Request.sign_header()
    |> Request.request()
    |> case do
      {:ok, %Req.Response{status: status, body: body, headers: headers}}
      when status in 200..299 ->
        {:ok, Response.parse(body, headers)}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, Error.build(status, body)}

      {:error, error} ->
        {:error, error}
    end
  end
end
