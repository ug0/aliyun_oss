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

  ## Examples

      iex> config = %{
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
      iex> Aliyun.Oss.Bucket.Lifecycle.put("some-bucket", config)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
      iex> config = ~S[
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
      iex> Aliyun.Oss.Bucket.Lifecycle.put("some-bucket", config)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

  """
  @spec put(Config.t(), String.t(), String.t() | map()) :: {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, %{} = config) do
    put(config, bucket, MapToXml.from_map(config))
  end

  def put(config, bucket, config) do
    put_bucket(config, bucket, %{"lifecycle" => nil}, config)
  end

  @doc """
  GetBucketLifecycle - get the lifecycle rules that are configured for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Lifecycle.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "LifecycleConfiguration" => %{
            "Rule" => %{
              "ID" => "delete after one day",
              "Prefix" => "logs/",
              "Status" => "Enabled",
              "Expiration" => %{
                "Days" => "1"
              }
            }
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, %{"lifecycle" => nil})
  end

  @doc """
  DeleteBucketLifecycle - deletes lifecycle rules for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Lifecycle.delete("some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:19:45 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C3000000000000000000000"},
          {"x-oss-server-time", "90"}
        ]
      }}
      iex> Aliyun.Oss.Bucket.Lifecycle.delete("unknown-bucket")
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "BucketName" => "unknown-bucket",
          "Code" => "NoSuchBucket",
          "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "The specified bucket does not exist.",
          "RequestId" => "5C38283EC84D1C4471F2F48A"
        },
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>",
        status_code: 404
      }}

  """
  @spec delete(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket) do
    delete_bucket(config, bucket, %{"lifecycle" => nil})
  end
end
