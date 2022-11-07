defmodule Aliyun.Oss.Bucket.Inventory do
  @moduledoc """
  Bucket Inventory 相关操作
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 2]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  PutBucketInventory接口用于为某个存储空间（Bucket）配置清单（Inventory）规则。

  ## Examples

      iex> config_json = %{
        "InventoryConfiguration" => %{
          "Destination" => %{
            "OSSBucketDestination" => %{
              "AccountId" => "100000000000000",
              "Bucket" => "acs:oss:::bucket_0001",
              "Encryption" => %{"SSE-KMS" => %{"KeyId" => "keyId"}},
              "Format" => "CSV",
              "Prefix" => "prefix1",
              "RoleArn" => "acs:ram::100000000000000:role/AliyunOSSRole"
            }
          },
          "Filter" => %{"Prefix" => "Pics"},
          "Id" => "56594298207FB304438516F9",
          "IncludedObjectVersions" => "All",
          "IsEnabled" => "true",
          "OptionalFields" => %{
            "Field" => ["Size", "LastModifiedDate", "ETag", "StorageClass",
            "IsMultipartUploaded", "EncryptionStatus"]
          },
          "Schedule" => %{"Frequency" => "Daily"}
        }
      }
      iex> Aliyun.Oss.Bucket.Inventory.put("some-bucket", "inventory_id", config_json)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
      iex> config_xml = ~S[
          <?xml version="1.0" encoding="UTF-8"?>
          <InventoryConfiguration>
            <Id>56594298207FB304438516F9</Id>
            <IsEnabled>true</IsEnabled>
            ...
          </InventoryConfiguration>
      ]
      iex> Aliyun.Oss.Bucket.Inventory.put("some-bucket", "inventory_id", config_xml)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
  """
  @spec put(String.t(), String.t(), String.t() | map()) :: {:error, error()} | {:ok, Response.t()}
  def put(bucket, inventory_id, %{} = config) do
    put(bucket, inventory_id, MapToXml.from_map(config))
  end

  def put(bucket, inventory_id, config) do
    put_bucket(bucket, %{}, %{"inventory" => nil, "inventoryId" => inventory_id}, config)
  end

  @doc """
  GetBucketInventory用于查看某个存储空间（Bucket）中指定的清单（Inventory）任务。

  ## Examples

      iex> Aliyun.Oss.Bucket.Inventory.get("some-bucket", "report1")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "InventoryConfiguration" => %{
            "Destination" => %{
              "OSSBucketDestination" => %{
                "AccountId" => "1000000000000000",
                "Bucket" => "acs:oss:::zidcn-test",
                "Format" => "CSV",
                "Prefix" => "inventory-report",
                "RoleArn" => "acs:ram::1000000000000000:role/AliyunOSSRole"
              }
            },
            "Filter" => %{"Prefix" => "prefix"},
            "Id" => "report1",
            "IncludedObjectVersions" => "Current",
            "IsEnabled" => "true",
            "OptionalFields" => %{
              "Field" => ["Size", "StorageClass", "LastModifiedDate", "ETag",
                "IsMultipartUploaded", "EncryptionStatus"]
            },
            "Schedule" => %{"Frequency" => "Weekly"}
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
  """
  @spec get(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(bucket, inventory_id) do
    get_bucket(bucket, %{}, %{"inventory" => nil, "inventoryId" => inventory_id})
  end

  @doc """
  ListBucketInventory用于批量获取某个存储空间（Bucket）中的所有清单（Inventory）任务。

  ## Examples

      iex> Aliyun.Oss.Bucket.Inventory.list("some-bucket", "report1")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "ListInventoryConfigurationsResult" => %{
            "ContinuationToken" => "inventory2",
            "InventoryConfiguration" => [
              # ...
            ],
            "IsTruncated" => false
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
  """
  @spec list(String.t(), nil | String.t()) :: {:error, error()} | {:ok, Response.t()}
  def list(bucket, continuation_token \\ nil) do
    get_bucket(bucket, %{}, %{"inventory" => nil, "continuation-token" => continuation_token})
  end

  @doc """
  DeleteBucketInventory用于删除某个存储空间（Bucket）中指定的清单（Inventory）任务。

  ## Examples

      iex> Aliyun.Oss.Bucket.Inventory.delete("some-bucket", "report1")
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
  @spec delete(String.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(bucket, inventory_id) do
    delete_bucket(bucket, %{"inventory" => nil, "inventoryId" => inventory_id})
  end
end
