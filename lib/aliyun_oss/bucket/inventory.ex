defmodule Aliyun.Oss.Bucket.Inventory do
  @moduledoc """
  Bucket operations - Inventory.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 3]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.Response

  @doc """
  PutBucketInventory - configures inventories for a bucket.

  ## Examples

      iex> config_xml = ~S[
          <?xml version="1.0" encoding="UTF-8"?>
          <InventoryConfiguration>
            <Id>inventory_id</Id>
            <IsEnabled>true</IsEnabled>
            ...
          </InventoryConfiguration>
      ]
      iex> Aliyun.Oss.Bucket.Inventory.put(config, "some-bucket", "inventory_id", config_xml)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec put(Config.t(), String.t(), String.t(), String.t()) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def put(config, bucket, inventory_id, config_xml) do
    put_bucket(config, bucket, config_xml,
      query_params: %{"inventory" => nil, "inventoryId" => inventory_id}
    )
  end

  @doc """
  GetBucketInventory - gets the specified inventory task configured for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Inventory.get(config, "some-bucket", "report1")
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
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec get(Config.t(), String.t(), String.t()) :: {:error, Exception.t()} | {:ok, Response.t()}
  def get(config, bucket, inventory_id) do
    get_bucket(config, bucket, query_params: %{"inventory" => nil, "inventoryId" => inventory_id})
  end

  @doc """
  ListBucketInventory - gets all inventory tasks configured for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Inventory.list(config, "some-bucket", "report1")
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
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}
  """
  @spec list(Config.t(), String.t(), nil | String.t()) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def list(config, bucket, continuation_token \\ nil) do
    get_bucket(config, bucket,
      query_params: %{
        "inventory" => nil,
        "continuation-token" => continuation_token
      }
    )
  end

  @doc """
  DeleteBucketInventory - deletes a specified inventory task of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Inventory.delete(config, "some-bucket", "report1")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Wed, 09 Jul 2025 01:50:11 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686DCAD31344************"],
          "x-oss-server-time" => ["33"]
        }
      }}

  """
  @spec delete(Config.t(), String.t(), String.t()) ::
          {:error, Exception.t()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket, inventory_id) do
    delete_bucket(config, bucket,
      query_params: %{"inventory" => nil, "inventoryId" => inventory_id}
    )
  end
end
