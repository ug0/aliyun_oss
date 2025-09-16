defmodule Aliyun.Oss.Service do
  @moduledoc false

  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client
  alias Aliyun.Oss.Client.Response

  @spec get(Config.t(), String.t() | nil, String.t() | nil, keyword()) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def get(%Config{} = config, bucket, object, options \\ []) do
    request(config, :get, bucket, object, "", options)
  end

  @spec post(Config.t(), String.t(), String.t() | nil, String.t(), keyword()) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def post(%Config{} = config, bucket, object, body, options \\ []) do
    request(config, :post, bucket, object, body, options)
  end

  @spec put(Config.t(), String.t(), String.t() | nil, String.t(), keyword()) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def put(%Config{} = config, bucket, object, body, options \\ []) do
    request(config, :put, bucket, object, body, options)
  end

  @spec delete(Config.t(), String.t(), String.t() | nil, keyword()) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def delete(%Config{} = config, bucket, object, options \\ []) do
    request(config, :delete, bucket, object, "", options)
  end

  @spec head(Config.t(), String.t(), String.t() | nil, keyword()) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def head(%Config{} = config, bucket, object, options \\ []) do
    request(config, :head, bucket, object, "", options)
  end

  defp request(%Config{} = config, method, bucket, object, body, options) do
    Client.request(
      config,
      method,
      bucket,
      object,
      Keyword.get(options, :headers, %{}),
      Keyword.get(options, :query_params, %{}),
      body
    )
  end

  @doc """
  ListBuckets - lists the information about all buckets.

  ## Options

  - `:query_params` - Defaults to `%{}`
  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Service.list_buckets(config)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "ListAllMyBucketResult" => %{
              "Buckets" => %{
                "Bucket" => [
                  %{
                    "CreationDate" => "2018-10-12T07:57:51.000Z",
                    "ExtranetEndpoint" => "oss-cn-shenzhen.aliyuncs.com",
                    "IntranetEndpoint" => "oss-cn-shenzhen-internal.aliyuncs.com",
                    "Location" => "oss-cn-shenzhen",
                    "Name" => "XXXXX",
                    "Region" => "cn-shenzhen",
                    "StorageClass" => "Standard"
                  },
                  ...
                ]
              },
              "IsTruncated" => true,
              "Marker" => nil,
              "MaxKeys" => 5,
              "NextMarker" => "XXXXX",
              "Owner" => %{"DislayName" => "11111111", "ID" => "11111111"},
              "Prefix" => nil
            }
          },
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

      iex> Aliyun.Oss.Service.list_buckets(config, query_params: %{"max-keys" => 100000})
      {:error,
        %Aliyun.Oss.Client.Error{
          status: 400,
          code: "InvalidArgument",
          message: "Argument max-keys must be an integer between 1 and 1000.",
          details: %{
            "ArgumentName" => "max-keys",
            "ArgumentValue" => "100000",
            "Code" => "InvalidArgument",
            "EC" => "0017-00000289",
            "HostId" => "oss-cn-shenzhen.aliyuncs.com",
            "Message" => "Argument max-keys must be an integer between 1 and 1000.",
            "RecommendDoc" => "https://api.aliyun.com/troubleshoot?q=0017-00000289",
            "RequestId" => "5BFF8912332CCD8D560F65D9"
          }
        }
      }

  """
  @spec list_buckets(Config.t(), keyword()) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def list_buckets(%Config{} = config, options \\ []) do
    request(config, :get, nil, nil, "", options)
  end
end
