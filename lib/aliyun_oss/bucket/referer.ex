defmodule Aliyun.Oss.Bucket.Referer do
  @moduledoc """
  Bucket Referer 相关操作
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketReferer 操作用于查看bucket的Referer相关配置。

  ## Examples

      iex> Aliyun.Oss.Bucket.Referer.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "RefererConfiguration" => %{
            "AllowEmptyReferer" => "true",
            "RefererList" => nil
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
    get_bucket(bucket, %{}, %{"referer" => nil})
  end

  @doc """
  PutBucketReferer接口用于设置Bucket的Referer访问白名单以及允许Referer字段是否为空。

  ## Examples

      iex> xml_body = \"""
      ...> <?xml version="1.0" encoding="UTF-8"?>
      ...> <RefererConfiguration>
      ...> <AllowEmptyReferer>true</AllowEmptyReferer >
      ...>     <RefererList>
      ...>         <Referer> http://www.aliyun.com</Referer>
      ...>         <Referer> https://www.aliyun.com</Referer>
      ...>         <Referer> http://www.*.com</Referer>
      ...>         <Referer> https://www.?.aliyuncs.com</Referer>
      ...>     </RefererList>
      ...> </RefererConfiguration>
      ...>  \"""
      iex> Aliyun.Oss.Bucket.Referer.put("some-bucket", xml_body)
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
    put_bucket(bucket, %{}, %{"referer" => nil}, xml_body)
  end
end
