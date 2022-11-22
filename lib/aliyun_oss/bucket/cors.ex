defmodule Aliyun.Oss.Bucket.CORS do
  @moduledoc """
  Bucket operations - CORS.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 4, put_bucket: 5, delete_bucket: 3]
  alias Aliyun.Oss.ConfigAlt, as: Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  PutBucketCors - configures cross-origin resource sharing (CORS) rules for a bucket.

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
  @spec put(Config.t(), String.t(), String.t() | map()) :: {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, %{} = config) do
    put(config, bucket, MapToXml.from_map(config))
  end

  def put(config, bucket, config) do
    put_bucket(config, bucket, %{}, %{"cors" => nil}, config)
  end

  @doc """
  GetBucketCors - gets the cross-origin resource sharing (CORS) rules configured for a specific bucket.

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
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, %{}, %{"cors" => nil})
  end

  @doc """
  DeleteBucketCors - disables cross-origin resource sharing (CORS) for a specific bucket and delete
  all CORS rules configured for the bucket.

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
  @spec delete(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket) do
    delete_bucket(config, bucket, %{"cors" => nil})
  end
end
