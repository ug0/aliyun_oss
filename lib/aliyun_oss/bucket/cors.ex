defmodule Aliyun.Oss.Bucket.CORS do
  @moduledoc """
  Bucket operations - CORS.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 3]
  alias Aliyun.Oss.Config
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
      iex> Aliyun.Oss.Bucket.CORS.put(config, "some-bucket", config_json)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}
      iex> config_xml = ~S[
      <?xml version="1.0" encoding="UTF-8"?>
      <CORSConfiguration>
      ...
      </CORSConfiguration >
      ]
      iex> Aliyun.Oss.Bucket.CORS.put(config, "some-bucket", config_xml)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec put(Config.t(), String.t(), String.t() | map()) :: {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, %{} = config_map) do
    put(config, bucket, MapToXml.from_map(config_map))
  end

  def put(config, bucket, config_xml) do
    put_bucket(config, bucket, config_xml, query_params: %{"cors" => nil})
  end

  @doc """
  GetBucketCors - gets the cross-origin resource sharing (CORS) rules configured for a specific bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.CORS.get(config, "some-bucket")
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
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, query_params: %{"cors" => nil})
  end

  @doc """
  DeleteBucketCors - disables cross-origin resource sharing (CORS) for a specific bucket and delete
  all CORS rules configured for the bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.CORS.delete(config, "some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Wed, 09 Jul 2025 07:31:57 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686E1AED****************"],
          "x-oss-server-time" => ["73"]
        }
      }}

  """
  @spec delete(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket) do
    delete_bucket(config, bucket, query_params: %{"cors" => nil})
  end
end
