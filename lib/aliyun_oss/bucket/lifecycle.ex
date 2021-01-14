defmodule Aliyun.Oss.Bucket.Lifecycle do
  @moduledoc """
  Bucket Lifecycle 相关操作
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 2]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() :: %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketLifecycle 用于查看Bucket的Lifecycle配置。

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
  @spec get(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(bucket) do
    get_bucket(bucket, %{}, %{"lifecycle" => nil})
  end

  @doc """
  通过DeleteBucketLifecycle接口来删除指定 Bucket 的生命周期规则。

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
  @spec delete(String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(bucket) do
    delete_bucket(bucket, %{"lifecycle" => nil})
  end
end
