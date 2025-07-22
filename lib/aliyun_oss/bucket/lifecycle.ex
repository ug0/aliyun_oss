defmodule Aliyun.Oss.Bucket.Lifecycle do
  @moduledoc """
  Bucket operations - Lifecycle.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 3]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  PutBucketLifecycle - configures a lifecycle rule for a bucket.

  ## Options

  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> lifecycle_config = %{
        "LifecycleConfiguration" => %{
          "Rule" => %{
            "AbortMultipartUpload" => %{"Days" => "1"},
            "Expiration" => %{"Days" => "1"},
            "ID" => "delete objects and parts after one day",
            "Prefix" => "logs/",
            "Status" => "Enabled"
          }
        }
      }
      iex> Aliyun.Oss.Bucket.Lifecycle.put(config, "some-bucket", lifecycle_config)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
      iex> lifecycle_config = ~S[
      <?xml version="1.0" encoding="UTF-8"?>
      <LifecycleConfiguration>
        <Rule>
          <ID>delete objects and parts after one day</ID>
          <Prefix>logs/</Prefix>
          <Status>Enabled</Status>
          <Expiration>
            <Days>1</Days>
          </Expiration>
          <AbortMultipartUpload>
            <Days>1</Days>
          </AbortMultipartUpload>
        </Rule>
      </LifecycleConfiguration>
      ]
      iex> Aliyun.Oss.Bucket.Lifecycle.put(config, "some-bucket", lifecycle_config)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec put(Config.t(), String.t(), String.t() | map(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, lifecycle_config, options \\ [])

  def put(config, bucket, %{} = lifecycle_config_map, options) do
    put(config, bucket, MapToXml.from_map(lifecycle_config_map), options)
  end

  def put(config, bucket, lifecycle_config_xml, options) do
    put_bucket(
      config,
      bucket,
      lifecycle_config_xml,
      Keyword.put(options, :query_params, %{"lifecycle" => nil})
    )
  end

  @doc """
  GetBucketLifecycle - get the lifecycle rules that are configured for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Lifecycle.get(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "LifecycleConfiguration" => %{
            "Rule" => %{
              "AbortMultipartUpload" => %{"Days" => "1"},
              "Expiration" => %{"Days" => "1"},
              "ID" => "delete objects and parts after one day",
              "Prefix" => "logs/",
              "Status" => "Enabled"
            }
          }
        },
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, query_params: %{"lifecycle" => nil})
  end

  @doc """
  DeleteBucketLifecycle - deletes lifecycle rules for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Lifecycle.delete("some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Tue, 08 Jul 2025 02:47:49 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686C0000000000000001C0B2"],
          "x-oss-server-time" => ["53"]
        }
      }}
      iex> Aliyun.Oss.Bucket.Lifecycle.delete("unknown-bucket")
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "BucketName" => "unknown-bucket",
          "Code" => "NoSuchBucket",
          "EC" => "0015-00000101",
          "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "The specified bucket does not exist.",
          "RecommendDoc" => "https://api.aliyun.com/troubleshoot?q=0015-00000101",
          "RequestId" => "5C38283EC84D1C4471F2F48A"
        },
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>",
        status_code: 404
      }}

  """
  @spec delete(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket) do
    delete_bucket(config, bucket, query_params: %{"lifecycle" => nil})
  end
end
