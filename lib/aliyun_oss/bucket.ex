defmodule Aliyun.Oss.Bucket do
  @moduledoc """
  Bucket operations - basic operations.

  Other operations can be found in:

  - `Aliyun.Oss.Bucket.WORM`
  - `Aliyun.Oss.Bucket.ACL`
  - `Aliyun.Oss.Bucket.Lifecycle`: Lifecycle 生命周期
  - `Aliyun.Oss.Bucket.Versioning`: Versioning 版本控制
  - `Aliyun.Oss.Bucket.Replication`: Replication 跨区域复制
  - `Aliyun.Oss.Bucket.Policy`: Policy 授权策略
  - `Aliyun.Oss.Bucket.Inventory`: Inventory 清单
  - `Aliyun.Oss.Bucket.Logging`: Logging 日志管理
  - `Aliyun.Oss.Bucket.Website`: Website 静态网站
  - `Aliyun.Oss.Bucket.Referer`: Referer 防盗链
  - `Aliyun.Oss.Bucket.Tags`: Tags 标签
  - `Aliyun.Oss.Bucket.Encryption`: Encryption 加密
  - `Aliyun.Oss.Bucket.RequestPayment`: RequestPayment 请求者付费
  - `Aliyun.Oss.Bucket.CORS`: CORS 跨域资源共享

  """

  alias Aliyun.Oss.ConfigAlt, as: Config
  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  ListBuckets - lists the information about all buckets.

  ## Examples

      iex> Aliyun.Oss.Bucket.list_buckets(config, %{"max-keys" => 5})
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
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
          },
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }

      iex> Aliyun.Oss.Bucket.list_buckets(config, %{"max-keys" => 100000})
      {:error,
        %Aliyun.Oss.Client.Error{
          status_code: 400,
          parsed_details: %{
            "ArgumentName" => "max-keys",
            "ArgumentValue" => "100000",
            "Code" => "InvalidArgument",
            "HostId" => "oss-cn-shenzhen.aliyuncs.com",
            "Message" => "Argument max-keys must be an integer between 1 and 1000.",
            "RequestId" => "5BFF8912332CCD8D560F65D9"
          },
          body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>"
        }
      }

  """
  @spec list_buckets(Config.t(), map()) :: {:error, error()} | {:ok, Response.t()}
  def list_buckets(%Config{} = config, query_params \\ %{}) do
    Service.get(config, nil, nil, query_params: query_params)
  end

  @doc """
  GetBucket (ListObjects) - lists the information about all objects in a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket(config, "some-bucket", %{"prefix" => "foo/"})
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
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
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
              "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
              "Message" => "The specified bucket does not exist.",
              "RequestId" => "5BFF89955E29FF66F10B9763"
            }
          },
          body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>"
        }
      }

  """
  @spec get_bucket(Config.t(), String.t(), map(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_bucket(%Config{} = config, bucket, query_params \\ %{}, sub_resources \\ %{}) do
    Service.get(config, bucket, nil, query_params: query_params, sub_resources: sub_resources)
  end

  @doc """
  GetBucketV2 (ListObjectsV2) - lists the information about all objects in a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.list_objects(config, "some-bucket", %{"prefix" => "foo/"})
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
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
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
              "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
              "Message" => "The specified bucket does not exist.",
              "RequestId" => "5BFF89955E29FF66F10B9763"
            }
          },
          body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>"
        }
      }

  """
  @spec list_objects(Config.t(), String.t(), map(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def list_objects(%Config{} = config, bucket, query_params \\ %{}, sub_resources \\ %{}) do
    get_bucket(config, bucket, Map.merge(query_params, %{"list-type" => 2}), sub_resources)
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
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"}
        ]
      }

  """
  @spec get_bucket_info(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_info(%Config{} = config, bucket) do
    get_bucket(config, bucket, %{}, %{"bucketInfo" => nil})
  end

  @doc """
  GetBucketLocation - views the location information of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_location(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"LocationConstraint" => "oss-cn-shenzhen"},
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"}
          ]
        }
      }
  """
  @spec get_bucket_location(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_location(%Config{} = config, bucket) do
    get_bucket(config, bucket, %{}, %{"location" => nil})
  end

  @doc """
  PutBucket - creates a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.put_bucket(config, "new-bucket", %{"x-oss-acl" => "private"})
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 04:35:39 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C381D000000000000000000"},
          {"Location", "/new-bucket"},
          {"x-oss-server-time", "438"}
        ]
      }}
      iex> Aliyun.Oss.Bucket.put_bucket(config, "new-bucket", %{"x-oss-acl" => "invalid-permission"}) # get error
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "ArgumentName" => "x-oss-acl",
          "ArgumentValue" => "invalid-permission",
          "Code" => "InvalidArgument",
          "HostId" => "new-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "no such bucket access control exists",
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
  @spec put_bucket(Config.t(), String.t(), map(), map(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put_bucket(
        %Config{} = config,
        bucket,
        headers = %{} \\ %{},
        sub_resources = %{} \\ %{},
        body \\ @body
      )
      when is_binary(body) do
    Service.put(config, bucket, nil, body, headers: headers, sub_resources: sub_resources)
  end

  @doc """
  DeleteBucket - deletes a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.delete_bucket(config, "some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:26:36 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C38290C41F2DE32412A3A88"},
          {"x-oss-server-time", "230"}
        ]
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
               </Error>",
        parsed_details: %{
          "BucketName" => "unknown-bucket",
          "Code" => "NoSuchBucket",
          "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "The specified bucket does not exist.",
          "RequestId" => "5C3000000000000000000000"
        },
        status_code: 404
      }}

  """
  @spec delete_bucket(Config.t(), String.t(), map()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete_bucket(%Config{} = config, bucket, sub_resources \\ %{}) do
    Service.delete(config, bucket, nil, sub_resources: sub_resources)
  end
end
