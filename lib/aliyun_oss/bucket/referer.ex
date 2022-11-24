defmodule Aliyun.Oss.Bucket.Referer do
  @moduledoc """
  Bucket operations - Referer.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 4, put_bucket: 5]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketReferer - gets the Referer configurations of a bucket.

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

  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, %{}, %{"referer" => nil})
  end

  @doc """
  PutBucketReferer - configures the Referer whitelist of a bucket.

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
  @spec put(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put(config, bucket, xml_body) do
    put_bucket(config, bucket, %{}, %{"referer" => nil}, xml_body)
  end
end
