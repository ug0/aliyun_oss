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
    |> IO.inspect()
    |> case do
      {:ok, %Req.Response{status: status, body: body, headers: headers}}
      when status in 200..299 ->
        {:ok, Response.parse(body, headers)}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, Error.parse(%Error{body: body, status_code: status})}

      {:error, %Jason.DecodeError{data: data}} ->
        {:error,
         %Error{body: data, status_code: 900, parsed_details: %{"message" => "JSON decode error"}}}

      {:error, %{reason: reason}} ->
        {:error, reason}
    end
  end
end
