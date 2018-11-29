defmodule Aliyun.Oss.Bucket do
  @moduledoc """
  Bucket 相关操作
  """

  import Aliyun.Oss.Config, only: [endpoint: 0]

  alias Aliyun.Oss.{Client, XmlParser}

  defstruct [:name, :location, :creation_date, :intranet_endpoint, :extranet_endpoint, :storage_class]

  @type error_details() :: {:http_error, String.t()} | {:xml_parse_error, String.t()} | {:oss_error, integer(), map()}

  @doc """
  GetService (ListBuckets)

  ## Examples

      iex> Aliyun.Oss.Bucket.list_buckets(%{"max-keys" => 5})
      {:ok, %{
        "Buckets" => %{
          "Bucket" => [
            %{
              "CreationDate" => "2018-10-12T07:57:51.000Z",
              "ExtranetEndpoint" => "oss-cn-shenzhen.aliyuncs.com",
              "IntranetEndpoint" => "oss-cn-shenzhen-internal.aliyuncs.com",
              "Location" => "oss-cn-shenzhen",
              "Name" => "XXXXX",
              "StorageClass" => "Standard"
            },
            ...
          ]
        },
        "IsTruncated" => true,
        "Marker" => nil,
        "MaxKeys" => 5,
        "NextMarker" => "XXXXX",
        "Owner" => %{"DislayName" => "11111111", "ID" => "11111111"},
        "Prefix" => nil
      }}

      iex> Aliyun.Oss.Bucket.list_buckets(%{"max-keys" => 100000})
      {:error,
        {:oss_error, 400,
          %{
            "ArgumentName" => "max-keys",
            "ArgumentValue" => "100000",
            "Code" => "InvalidArgument",
            "HostId" => "oss-cn-shenzhen.aliyuncs.com",
            "Message" => "Argument max-keys must be an integer between 1 and 1000.",
            "RequestId" => "5BFF8912332CCD8D560F65D9"
          }}}
  """
  @spec list_buckets(map(), map()) :: {:error, error_details()} | {:ok, map()}
  def list_buckets(query_params \\ %{}, sub_resources \\ %{}) do
    case Client.request(%{
      verb: "GET",
      host: endpoint(),
      path: "/",
      resource: "/",
      query_params: query_params,
      sub_resources: sub_resources
    }) do
      {:ok, xml} -> parse_xml(xml, "ListAllMyBucketsResult")
      error_res -> error_res
    end
  end

  @doc """
  GetBucket (ListObject)

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket("some-bucket", %{"prefix" => "foo/"})
      {:ok, %{
        "Contents" => [
          %{
            "ETag" => "\"D410293F000B000D00D\"",
            "key" => "foo/bar",
            "LastModified" => "2018-09-12T02:59:41.000Z",
            "Owner" => %{"DislayName" => "11111111", "ID" => "11111111"},
            "Size" => "12345",
            "StorageClass" => "IA",
            "Type" => "Normal"
          },
          ...
        ],
        "Delimiter" => nil,
        "IsTruncated" => true,
        "Marker" => nil,
        "MaxKeys" => 100,
        "Name" => "some-bucket",
        "NextMarker" => "XXXXX",
        "Prefix" => "foo/"
      }}

      iex> Aliyun.Oss.Bucket.get_bucket("unknown-bucket")
      {:error,
        {:oss_error, 404,
          %{
            "BucketName" => "unknown-bucket",
            "Code" => "NoSuchBucket",
            "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
            "Message" => "The specified bucket does not exist.",
            "RequestId" => "5BFF89955E29FF66F10B9763"
          }}}
  """
  @spec get_bucket(String.t(), map(), map()) :: {:error, error_details()} | {:ok, map()}
  def get_bucket(bucket, query_params \\ %{}, sub_resources \\ %{}) do
    host = bucket <> "." <> endpoint()
    case Client.request(%{
      verb: "GET",
      host: host,
      resource: "/#{bucket}/",
      path: "/",
      query_params: query_params,
      sub_resources: sub_resources
    }) do
      {:ok, xml} -> parse_xml(xml, "ListBucketResult")
      error_res -> error_res
    end
  end

  defp parse_xml(xml, root_node) do
    case XmlParser.parse_xml(xml, root_node) do
      {:ok, result} -> {:ok, result}
      {:error, message} -> {:error, {:xml_parse_error, message}}
    end
  end
end
