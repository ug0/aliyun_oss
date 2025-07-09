defmodule Aliyun.Oss.Bucket.Referer do
  @moduledoc """
  Bucket operations - Referer.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketReferer - gets the Referer configurations of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Referer.get(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "RefererConfiguration" => %{
            "AllowEmptyReferer" => "true",
            "AllowTruncateQueryString" => "true",
            "RefererList" => nil,
            "TruncatePath" => "false"
          }
        },
        headers: %{
          "connection" => "keep-alive",
          ...
        }
      }}

  """

  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, query_params: %{"referer" => nil})
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
      iex> Aliyun.Oss.Bucket.Referer.put(config, "some-bucket", xml_body)
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Wed, 09 Jul 2025 05:35:55 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686DFFBBABB8F***********"],
          "x-oss-server-time" => ["54"]
        }
      }}

  """
  @spec put(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put(config, bucket, xml_body) do
    put_bucket(config, bucket, xml_body, query_params: %{"referer" => nil})
  end
end
