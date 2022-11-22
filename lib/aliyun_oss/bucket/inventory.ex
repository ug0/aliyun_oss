defmodule Aliyun.Oss.Bucket.Inventory do
  @moduledoc """
  Bucket operations - Inventory.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 4, put_bucket: 5, delete_bucket: 3]
  alias Aliyun.Oss.ConfigAlt, as: Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  PutBucketInventory - configures inventories for a bucket.

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
  @spec put(Config.t(), String.t(), String.t(), String.t() | map()) ::
          {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, inventory_id, %{} = config) do
    put(config, bucket, inventory_id, MapToXml.from_map(config))
  end

  def put(config, bucket, inventory_id, config) do
    put_bucket(config, bucket, %{}, %{"inventory" => nil, "inventoryId" => inventory_id}, config)
  end

  @doc """
  GetBucketInventory - gets the specified inventory task configured for a bucket.

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
  @spec get(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket, inventory_id) do
    get_bucket(config, bucket, %{}, %{"inventory" => nil, "inventoryId" => inventory_id})
  end

  @doc """
  ListBucketInventory - gets all inventory tasks configured for a bucket.

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
  @spec list(Config.t(), String.t(), nil | String.t()) :: {:error, error()} | {:ok, Response.t()}
  def list(config, bucket, continuation_token \\ nil) do
    get_bucket(config, bucket, %{}, %{
      "inventory" => nil,
      "continuation-token" => continuation_token
    })
  end

  @doc """
  DeleteBucketInventory - deletes a specified inventory task of a bucket.

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
  @spec delete(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket, inventory_id) do
    delete_bucket(config, bucket, %{"inventory" => nil, "inventoryId" => inventory_id})
  end
end
