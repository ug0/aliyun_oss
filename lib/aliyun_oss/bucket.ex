defmodule Aliyun.Oss.Bucket do
  @moduledoc """
  Bucket 相关操作
  """

  import Aliyun.Oss.Config, only: [endpoint: 0]

  alias Aliyun.Oss.Service

  @type error_details() :: {:http_error, String.t()} | {:xml_parse_error, String.t()} | {:oss_error, integer(), map()}

  @doc """
  GetService (ListBuckets) 对于服务地址作Get请求可以返回请求者拥有的所有Bucket。

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
  @spec list_buckets(map()) :: {:error, error_details()} | {:ok, map()}
  def list_buckets(query_params \\ %{}) do
    Service.get(endpoint(), "/", "/", query_params)
  end

  @doc """
  GetBucket(ListObject) 接口可用来列出 Bucket中所有Object的信息。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket("some-bucket", %{"prefix" => "foo/"})
      {:ok, %{ "ListAllMyBucketsResult" => %{
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
      }}}

      iex> Aliyun.Oss.Bucket.get_bucket("unknown-bucket")
      {:error,
        {:oss_error, 404,
          %{ "ListBucketResult" => %{
            "BucketName" => "unknown-bucket",
            "Code" => "NoSuchBucket",
            "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
            "Message" => "The specified bucket does not exist.",
            "RequestId" => "5BFF89955E29FF66F10B9763"
          }}}}

    注：所有 GetBucketXXX 相关操作亦可由此接口实现, 即 Bucket.get_bucket_acl("some-bucket") 等同于 Bucket.get_bucket("some-bucket", %{}, %{"acl" => nil})
  """
  @spec get_bucket(String.t(), map(), map()) :: {:error, error_details()} | {:ok, map()}
  def get_bucket(bucket, query_params \\ %{}, sub_resources \\ %{}) do
    Service.get("#{bucket}.#{endpoint()}", "/", "/#{bucket}/", query_params, sub_resources)
  end

  @doc """
  GetBucketAcl 接口用来获取某个Bucket的访问权限。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_acl("some-bucket")
      {:ok, %{ "AccessControlPolicy" => %{
        "AccessControlList" => %{"Grant" => "private"},
        "Owner" => %{"DislayName" => "11111111", "ID" => "11111111"}
      }}}
  """
  @spec get_bucket_acl(String.t()) :: {:error, error_details()} | {:ok, map()}
  def get_bucket_acl(bucket) do
    get_bucket(bucket, %{}, %{"acl" => nil})
  end

  @doc """
  GetBucketLocation
  GetBucketLocation用于查看Bucket所属的数据中心位置信息。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_location("some-bucket")
      {:ok, %{"LocationConstraint" => "oss-cn-shenzhen"}}
  """
  @spec get_bucket_location(String.t()) :: {:error, error_details()} | {:ok, map()}
  def get_bucket_location(bucket) do
    get_bucket(bucket, %{}, %{"location" => nil})
  end

  @doc """
  GetBucketInfo 接口用于查看bucket的相关信息。
  可查看内容包含如下：

    - 创建时间
    - 外网访问Endpoint
    - 内网访问Endpoint
    - bucket的拥有者信息
    - bucket的ACL（AccessControlList）

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_info("some-bucket")
      {:ok,
      %{ "BucketInfo" => %{
        "Bucket" => %{
          "AccessControlList" => %{"Grant" => "private"},
          "Comment" => nil,
          "CreationDate" => "2018-08-29T01:52:03.000Z",
          "DataRedundancyType" => "LRS",
          "ExtranetEndpoint" => "oss-cn-shenzhen.aliyuncs.com",
          "IntranetEndpoint" => "oss-cn-shenzhen-internal.aliyuncs.com",
          "Location" => "oss-cn-shenzhen",
          "Name" => "some-bucket",
          "Owner" => %{
            "DisplayName" => "11111111",
            "ID" => "11111111"
          },
          "StorageClass" => "IA"
        }
      }}}
  """
  @spec get_bucket_info(String.t()) :: {:error, error_details()} | {:ok, map()}
  def get_bucket_info(bucket) do
    get_bucket(bucket, %{}, %{"bucketInfo" => nil})
  end
end
