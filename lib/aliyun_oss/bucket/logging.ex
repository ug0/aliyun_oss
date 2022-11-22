defmodule Aliyun.Oss.Bucket.Logging do
  @moduledoc """
  Bucket Inventory - Logging.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 4, put_bucket: 5, delete_bucket: 3]
  alias Aliyun.Oss.ConfigAlt, as: Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketLogging - gets the access logging configuration of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Logging.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "BucketLoggingStatus" => %{
            "LoggingEnabled" => %{
              "TargetBucket" => "some-bucket",
              "TargetPrefix" => "oss-accesslog/"
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
    get_bucket(config, bucket, %{}, %{"logging" => nil})
  end

  @doc """
  PutBucketLogging - enables logging for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Logging.put("some-bucket", "target-bucket", "target-prefix")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:05:50 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"x-oss-server-time", "63"}
        ]
      }}

  """

  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <BucketLoggingStatus>
    <LoggingEnabled>
      <TargetBucket><%= target_bucket %></TargetBucket>
      <TargetPrefix><%= target_prefix %></TargetPrefix>
    </LoggingEnabled>
  </BucketLoggingStatus>
  """
  @spec put(Config.t(), String.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put(config, bucket, target_bucket, target_prefix \\ "oss-accesslog/") do
    body =
      EEx.eval_string(
        @body_tmpl,
        target_bucket: target_bucket,
        target_prefix: target_prefix
      )

    put_bucket(config, bucket, %{}, %{"logging" => nil}, body)
  end

  @doc """
  DeleteBucketLogging - deletes the logging configurations for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Logging.delete("some-bucket")
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
      iex> Aliyun.Oss.Bucket.Logging.delete("unknown-bucket")
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
    delete_bucket(config, bucket, %{"logging" => nil})
  end
end
