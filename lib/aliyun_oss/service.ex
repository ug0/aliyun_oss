defmodule Aliyun.Oss.Service do
  @moduledoc false

  alias Aliyun.Oss.Client
  alias Aliyun.Oss.Client.{Response, Error}
  import Aliyun.Oss.Config, only: [endpoint: 0]

  @type error() :: %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @spec get(String.t() | nil, String.t() | nil, keyword()) :: {:error, error()} | {:ok, Response.t()}
  def get(bucket, object, opts \\ []) do
    request("GET", bucket, object, "", opts)
  end

  @spec post(String.t(), String.t() | nil, String.t(), keyword()) :: {:error, error()} | {:ok, Response.t()}
  def post(bucket, object, body, opts \\ []) do
    request("POST", bucket, object, body, opts)
  end

  @spec put(String.t(), String.t() | nil, String.t(), keyword()) :: {:error, error()} | {:ok, Response.t()}
  def put(bucket, object, body, opts \\ []) do
    request("PUT", bucket, object, body, opts)
  end

  @spec delete(String.t(), String.t() | nil, keyword()) :: {:error, error()} | {:ok, Response.t()}
  def delete(bucket, object, opts \\ []) do
    request("DELETE", bucket, object, "", opts)
  end

  @spec head(String.t(), String.t() | nil, keyword()) :: {:error, error()} | {:ok, Response.t()}
  def head(bucket, object, opts \\ []) do
    request("HEAD", bucket, object, "", opts)
  end

  defp request(verb, bucket, object, body, opts) do
    {host, resource} =
      case bucket do
        <<_, _::binary>> -> {"#{bucket}.#{endpoint()}", "/#{bucket}/#{object}"}
        _ -> {endpoint(), "/"}
      end

    Client.request(%{
      verb: verb,
      body: body,
      host: host,
      path: "/#{object}",
      resource: resource,
      query_params: Keyword.get(opts, :query_params, %{}),
      headers: Keyword.get(opts, :headers, %{}),
      sub_resources: Keyword.get(opts, :sub_resources, %{})
    })
  end
end
