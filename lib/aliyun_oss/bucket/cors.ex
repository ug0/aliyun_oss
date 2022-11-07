defmodule Aliyun.Oss.Bucket.CORS do
  @moduledoc """
  Bucket CORS 相关操作
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 2]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  PutBucketCors接口用于为指定的存储空间（Bucket）设置跨域资源共享CORS（Cross-Origin Resource Sharing）规则。

  ## Examples

      iex> config_json = %{
        "CORSConfiguration" => %{
          "CORSRule" => [
            %{
              "AllowedHeader" => "Authorization",
              "AllowedMethod" => ["PUT", "GET"],
              "AllowedOrigin" => "*"
            },
            %{
              "AllowedHeader" => "Authorization",
              "AllowedMethod" => "GET",
              "AllowedOrigin" => ["http://www.a.com", "http://www.b.com"],
              "ExposeHeader" => ["x-oss-test", "x-oss-test1"],
              "MaxAgeSeconds" => "100"
            }
          ],
          "ResponseVary" => "false"
        }
      }
      iex> Aliyun.Oss.Bucket.CORS.put("some-bucket", config_json)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
      iex> config_xml = ~S[
      <?xml version="1.0" encoding="UTF-8"?>
      <CORSConfiguration>
      ...
      </CORSConfiguration >
      ]
      iex> Aliyun.Oss.Bucket.CORS.put("some-bucket", config_xml)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
  """
  @spec put(String.t(), String.t() | map()) :: {:error, error()} | {:ok, Response.t()}
  def put(bucket, %{} = config) do
    put(bucket, MapToXml.from_map(config))
  end

  def put(bucket, config) do
    put_bucket(bucket, %{}, %{"cors" => nil}, config)
  end

  @doc """
  GetBucketCors接口用于获取指定存储空间（Bucket）当前的跨域资源共享CORS（Cross-Origin Resource Sharing）规则。

  ## Examples

      iex> Aliyun.Oss.Bucket.CORS.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "CORSConfiguration" => %{
            "CORSRule" => [
              %{
                "AllowedHeader" => "authorization",
                "AllowedMethod" => ["PUT", "GET"],
                "AllowedOrigin" => "*"
              },
              %{
                "AllowedHeader" => "authorization",
                "AllowedMethod" => "GET",
                "AllowedOrigin" => ["http://www.a.com", "http://www.b.com"],
                "ExposeHeader" => ["x-oss-test", "x-oss-test1"],
                "MaxAgeSeconds" => "100"
              }
            ],
            "ResponseVary" => "false"
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
    get_bucket(bucket, %{}, %{"cors" => nil})
  end

  @doc """
  DeleteBucketCors用于关闭指定存储空间（Bucket）对应的跨域资源共享CORS（Cross-Origin Resource Sharing）功能并清空所有规则。

  ## Examples

      iex> Aliyun.Oss.Bucket.CORS.delete("some-bucket")
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
  """
  @spec delete(String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(bucket) do
    delete_bucket(bucket, %{"cors" => nil})
  end
end
