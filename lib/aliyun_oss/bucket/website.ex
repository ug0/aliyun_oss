defmodule Aliyun.Oss.Bucket.Website do
  @moduledoc """
  Bucket Website 相关操作
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 2]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() :: %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketWebsite 接口用于查看bucket的静态网站托管状态以及跳转规则。

  ## Examples

      iex> Aliyun.Oss.Bucket.Website.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "WebsiteConfiguration" => %{"IndexDocument" => %{"Suffix" => "index.html"}}
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

      iex> Aliyun.Oss.Bucket.Website.get("unkown-bucket")
      {:error,
        %Aliyun.Oss.Client.Error{
          status_code: 404,
          parsed_details: %{
            "BucketName" => "unkown-bucket",
            "Code" => "NoSuchBucket",
            "HostId" => "unkown-bucket.oss-cn-shenzhen.aliyuncs.com",
            "Message" => "The specified bucket does not exist.",
            "RequestId" => "5C0000000000000000000000"
          },
          body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>"
        }
      }
  """
  @spec get(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(bucket) do
    get_bucket(bucket, %{}, %{"website" => nil})
  end

  @doc """
  PutBucketWebsite接口用于将一个bucket设置成静态网站托管模式，以及设置跳转规则。

  ## Examples

      iex> xml_body = \"""
      ...> <?xml version="1.0" encoding="UTF-8"?>
      ...> <WebsiteConfiguration>
      ...> <IndexDocument>
      ...>   <Suffix>index.html</Suffix>
      ...> </IndexDocument>
      ...> ...
      ...> ...
      ...> </WebsiteConfiguration>
      ...>  \"""
      iex> Aliyun.Oss.Bucket.Website.put("some-bucket", xml_body)
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
  @spec put(String.t(), String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put(bucket, xml_body) do
    put_bucket(bucket, %{}, %{"website" => nil}, xml_body)
  end

  @doc """
  DeleteBucketWebsite操作用于关闭Bucket的静态网站托管模式以及跳转规则。

  ## Examples

      iex> Aliyun.Oss.Bucket.Website.delete("some-bucket")
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
      iex> Aliyun.Oss.Bucket.Website.delete("unknown-bucket")
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
    delete_bucket(bucket, %{"website" => nil})
  end
end
