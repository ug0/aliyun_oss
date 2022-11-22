defmodule Aliyun.Oss.Service do
  @moduledoc false

  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @spec get(Config.t(), String.t() | nil, String.t() | nil, keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def get(%Config{} = config, bucket, object, opts \\ []) do
    request(config, "GET", bucket, object, "", opts)
  end

  @spec post(Config.t(), String.t(), String.t() | nil, String.t(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def post(%Config{} = config, bucket, object, body, opts \\ []) do
    request(config, "POST", bucket, object, body, opts)
  end

  @spec put(Config.t(), String.t(), String.t() | nil, String.t(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def put(%Config{} = config, bucket, object, body, opts \\ []) do
    request(config, "PUT", bucket, object, body, opts)
  end

  @spec delete(Config.t(), String.t(), String.t() | nil, keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def delete(%Config{} = config, bucket, object, opts \\ []) do
    request(config, "DELETE", bucket, object, "", opts)
  end

  @spec head(Config.t(), String.t(), String.t() | nil, keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def head(%Config{} = config, bucket, object, opts \\ []) do
    request(config, "HEAD", bucket, object, "", opts)
  end

  defp request(%Config{} = config, verb, bucket, object, body, opts) do
    %{endpoint: endpoint} = config

    {host, resource} =
      case bucket do
        <<_, _::binary>> -> {"#{bucket}.#{endpoint}", "/#{bucket}/#{object}"}
        _ -> {endpoint, "/"}
      end

    Client.request(config, %{
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
