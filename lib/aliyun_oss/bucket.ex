defmodule Aliyun.Oss.Bucket do
  @moduledoc """
  Bucket operations - basic operations.

  Other operations can be found in:

  - `Aliyun.Oss.Bucket.WORM`
  - `Aliyun.Oss.Bucket.ACL`
  - `Aliyun.Oss.Bucket.Lifecycle`
  - `Aliyun.Oss.Bucket.Versioning`
  - `Aliyun.Oss.Bucket.Replication`
  - `Aliyun.Oss.Bucket.Policy`
  - `Aliyun.Oss.Bucket.Inventory`
  - `Aliyun.Oss.Bucket.Logging`
  - `Aliyun.Oss.Bucket.Website`
  - `Aliyun.Oss.Bucket.Referer`
  - `Aliyun.Oss.Bucket.Tags`
  - `Aliyun.Oss.Bucket.Encryption`
  - `Aliyun.Oss.Bucket.RequestPayment`
  - `Aliyun.Oss.Bucket.CORS`

  """

  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()


  defdelegate list_buckets(config, options \\ []), to: Service

  @doc """
  GetBucket (ListObjects) - lists the information about all objects in a bucket.

  ## Options

  - `:query_params` - Defaults to `%{}`
  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket(config, "some-bucket", query_params: %{"prefix" => "foo/"})
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "ListBucketResult" => %{
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
            }
          },
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

      iex> Aliyun.Oss.Bucket.get_bucket(config, "unknown-bucket")
      {:error,
        %Aliyun.Oss.Client.Error{
          status_code: 404,
          parsed_details: %{
            "ListBucketResult" => %{
              "BucketName" => "unknown-bucket",
              "Code" => "NoSuchBucket",
              "EC" => "0015-00000101",
              "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
              "Message" => "The specified bucket does not exist.",
              "RecommendDoc" => "https://api.aliyun.com/troubleshoot?q=0015-00000101",
              "RequestId" => "5BFF89955E29FF66F10B9763"
            }
          },
          body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>"
        }
      }

  """
  @spec get_bucket(Config.t(), String.t(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_bucket(%Config{} = config, bucket, options \\ []) do
    Service.get(config, bucket, nil, options)
  end

  @doc """
  GetBucketV2 (ListObjectsV2) - lists the information about all objects in a bucket.

  ## Options

  - `:query_params` - Defaults to `%{}`
  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Bucket.list_objects(config, "some-bucket", query_params: %{"prefix" => "foo/"})
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "ListBucketResult" => %{
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
              "KeyCount" => 100,
              "MaxKeys" => 100,
              "Name" => "some-bucket",
              "NextContinuationToken" => "XXXXX",
              "Prefix" => "foo/"
            }
          },
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

      iex> Aliyun.Oss.Bucket.list_objects(config, "unknown-bucket")
      {:error,
        %Aliyun.Oss.Client.Error{
          status_code: 404,
          parsed_details: %{
            "ListBucketResult" => %{
              "BucketName" => "unknown-bucket",
              "Code" => "NoSuchBucket",
              "EC" => "0015-00000101",
              "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
              "Message" => "The specified bucket does not exist.",
              "RecommendDoc" => "https://api.aliyun.com/troubleshoot?q=0015-00000101",
              "RequestId" => "5BFF89955E29FF66F10B9763"
            }
          },
          body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>"
        }
      }

  """
  @query_params %{"list-type" => 2}
  @spec list_objects(Config.t(), String.t(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def list_objects(%Config{} = config, bucket, options \\ []) do
    get_bucket(config, bucket, Keyword.update(options, :query_params, @query_params, &Map.merge(&1, @query_params)))
  end

  @doc """
  GetBucketInfo - gets the information about a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_info(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "BucketInfo" => %{
            "Bucket" => %{
              "AccessControlList" => %{"Grant" => "private"},
              "AccessMonitor" => "Disabled",
              "BlockPublicAccess" => "false",
              "BucketPolicy" => %{"LogBucket" => nil, "LogPrefix" => nil},
              "Comment" => nil,
              "CreationDate" => "2018-08-29T01:52:03.000Z",
              "CrossRegionReplication" => "Disabled",
              "DataRedundancyType" => "LRS",
              "ExtranetEndpoint" => "oss-cn-shenzhen.aliyuncs.com",
              "IntranetEndpoint" => "oss-cn-shenzhen-internal.aliyuncs.com",
              "Location" => "oss-cn-shenzhen",
              "Name" => "some-bucket",
              "Owner" => %{
                "DisplayName" => "11111111",
                "ID" => "11111111"
              },
              "ResourceGroupId" => "rg-acfmvqvnke6otqi",
              "ResourcePoolConfig" => nil,
              "ServerSideEncryptionRule" => %{"SSEAlgorithm" => "None"},
              "StorageClass" => "IA",
              "TransferAcceleration" => "Disabled",
              "Versioning" => "Suspended"
            }
          }
        },
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }

  """
  @spec get_bucket_info(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_info(%Config{} = config, bucket) do
    get_bucket(config, bucket, query_params: %{"bucketInfo" => nil})
  end

  @doc """
  GetBucketLocation - views the location information of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_location(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"LocationConstraint" => "oss-cn-shenzhen"},
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }
  """
  @spec get_bucket_location(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_location(%Config{} = config, bucket) do
    get_bucket(config, bucket, query_params: %{"location" => nil})
  end

  @doc """
  GetBucketStat - views the storage and objects count information of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_stat(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "ArchiveObjectCount" => "0",
            "ArchiveRealStorage" => "0",
            "ArchiveStorage" => "0",
            "ColdArchiveObjectCount" => "0",
            "ColdArchiveRealStorage" => "0",
            "ColdArchiveStorage" => "0",
            "DeepColdArchiveObjectCount" => "0",
            "DeepColdArchiveRealStorage" => "0",
            "DeepColdArchiveStorage" => "0",
            "DeleteMarkerCount" => "303",
            "InfrequentAccessObjectCount" => "0",
            "InfrequentAccessRealStorage" => "0",
            "InfrequentAccessStorage" => "0",
            "LastModifiedTime" => "1751610223",
            "LiveChannelCount" => "2",
            "MultipartPartCount" => "0",
            "MultipartUploadCount" => "0",
            "ObjectCount" => "19",
            "StandardObjectCount" => "19",
            "StandardStorage" => "3166616",
            "Storage" => "3166616"
          },
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }
  """
  @spec get_bucket_stat(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_stat(%Config{} = config, bucket) do
    get_bucket(config, bucket, query_params: %{"stat" => nil})
  end

  @doc """
  PutBucket - creates a bucket.

  ## Options

  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> body = ~S{
      <?xml version="1.0" encoding="UTF-8"?>
      <CreateBucketConfiguration>
        <StorageClass>Standard</StorageClass>
      </CreateBucketConfiguration>
      }
      iex> Aliyun.Oss.Bucket.put_bucket(config, "new-bucket", body, headers: %{"x-oss-acl" => "private"})
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Fri, 11 Jan 2019 04:35:39 GMT"],
          "location" => ["/new-bucket"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["5C381D000000000000000000"],
          "x-oss-server-time" => ["438"]
        }
      }}
      iex> Aliyun.Oss.Bucket.put_bucket(config, "new-bucket", body, headers: %{"x-oss-acl" => "invalid-permission"}) # get error
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "ArgumentName" => "x-oss-acl",
          "ArgumentValue" => "invalid-permission",
          "Code" => "InvalidArgument",
          "EC" => "0015-00000204",
          "HostId" => "new-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "no such bucket access control exists",
          "RecommendDoc" => "https://api.aliyun.com/troubleshoot?q=0015-00000204",
          "RequestId" => "5C3000000000000000000000"
        },
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>",
        status_code: 400
      }}

  """
  @body """
  <?xml version="1.0" encoding="UTF-8"?>
  <CreateBucketConfiguration>
    <StorageClass>Standard</StorageClass>
  </CreateBucketConfiguration>
  """
  @spec put_bucket(Config.t(), String.t(), String.t(), keyword()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put_bucket(
        %Config{} = config,
        bucket,
        body \\ @body,
        options \\ []
      )
      when is_binary(body) do
    Service.put(config, bucket, nil, body, options)
  end

  @doc """
  DeleteBucket - deletes a bucket.

  ## Options

  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Bucket.delete_bucket(config, "some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Fri, 11 Jan 2019 05:26:36 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["5C38290C41F2DE32412A3A88"],
          "x-oss-server-time" => ["230"]
        }
      }}
      iex> Aliyun.Oss.Bucket.delete_bucket(config, "unknown-bucket")
      {:error,
      %Aliyun.Oss.Client.Error{
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
               <Error>\n\
                 <Code>NoSuchBucket</Code>\n\
                 <Message>The specified bucket does not exist.</Message>\n\
                 <RequestId>5C3829B29BF380354CF9C2E8</RequestId>\n\
                 <HostId>unknown-bucket.oss-cn-shenzhen.aliyuncs.com</HostId>\n\
                 <BucketName>unknown-bucket</BucketName>\n\
                 <EC>0015-00000101</EC>\n
                 <RecommendDoc>https://api.aliyun.com/troubleshoot?q=0015-00000101</RecommendDoc>
               </Error>",
        parsed_details: %{
          "BucketName" => "unknown-bucket",
          "Code" => "NoSuchBucket",
          "EC" => "0015-00000101",
          "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "The specified bucket does not exist.",
          "RecommendDoc" => "https://api.aliyun.com/troubleshoot?q=0015-00000101",
          "RequestId" => "5C3000000000000000000000"
        },
        status_code: 404
      }}

  """
  @spec delete_bucket(Config.t(), String.t(), keyword()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete_bucket(%Config{} = config, bucket, options \\ []) do
    Service.delete(config, bucket, nil, options)
  end
end
