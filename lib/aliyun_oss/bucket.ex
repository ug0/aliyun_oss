defmodule Aliyun.Oss.Bucket do
  @moduledoc """
  Bucket 相关操作
  """

  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() :: %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetService (ListBuckets) 对于服务地址作Get请求可以返回请求者拥有的所有Bucket。

  ## Examples

      iex> Aliyun.Oss.Bucket.list_buckets(%{"max-keys" => 5})
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

      iex> Aliyun.Oss.Bucket.list_buckets(%{"max-keys" => 100000})
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
  @spec list_buckets(map()) :: {:error, error()} | {:ok, Response.t()}
  def list_buckets(query_params \\ %{}) do
    Service.get(nil, nil, query_params: query_params)
  end

  @doc """
  GetBucket(ListObject) 接口可用来列出 Bucket中所有Object的信息。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket("some-bucket", %{"prefix" => "foo/"})
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

      iex> Aliyun.Oss.Bucket.get_bucket("unknown-bucket")
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

    注：所有 GetBucketXXX 相关操作亦可由此接口实现, 即 Bucket.get_bucket_acl("some-bucket") 等同于 Bucket.get_bucket("some-bucket", %{}, %{"acl" => nil})
  """
  @spec get_bucket(String.t(), map(), map()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket(bucket, query_params \\ %{}, sub_resources \\ %{}) do
    Service.get(bucket, nil, query_params: query_params, sub_resources: sub_resources)
  end

  @doc """
  GetBucketAcl 接口用来获取某个Bucket的访问权限。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_acl("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "AccessControlPolicy" => %{
              "AccessControlList" => %{"Grant" => "private"},
              "Owner" => %{"DislayName" => "11111111", "ID" => "11111111"}
            }
          },
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"}
          ]
        }
      }
  """
  @spec get_bucket_acl(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_acl(bucket) do
    get_bucket(bucket, %{}, %{"acl" => nil})
  end

  @doc """
  GetBucketLocation
  GetBucketLocation用于查看Bucket所属的数据中心位置信息。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_location("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"LocationConstraint" => "oss-cn-shenzhen"},
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"}
          ]
        }
      }
  """
  @spec get_bucket_location(String.t()) :: {:error, error()} | {:ok, Response.t()}
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
  @spec get_bucket_info(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_info(bucket) do
    get_bucket(bucket, %{}, %{"bucketInfo" => nil})
  end

  @doc """
  GetBucketLogging 用于查看Bucket的访问日志配置情况。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_logging("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "BucketLoggingStatus" => %{
            "LoggingEnabled" => %{
              "TargetBucket" => "some-bucket",
              "TargetPrefix" => "oss-accesslog/"
            }
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
  """
  @spec get_bucket_logging(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_logging(bucket) do
    get_bucket(bucket, %{}, %{"logging" => nil})
  end

  @doc """
  GetBucketWebsite 接口用于查看bucket的静态网站托管状态以及跳转规则。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_website("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "WebsiteConfiguration" => %{"IndexDocument" => %{"Suffix" => "index.html"}}
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

      iex> Aliyun.Oss.Bucket.get_bucket_website("unkown-bucket")
      {:error,
        %Aliyun.Oss.Client.Error{
          status_code: 404,
          parsed_details: %{
            "BucketName" => "unkown-bucket",
            "Code" => "NoSuchBucket",
            "HostId" => "unkown-bucket.oss-cn-shenzhen.aliyuncs.com",
            "Message" => "The specified bucket does not exist.",
            "RequestId" => "5C0000000000000000000000"
          },
          body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>"
        }
      }
  """
  @spec get_bucket_website(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_website(bucket) do
    get_bucket(bucket, %{}, %{"website" => nil})
  end

  @doc """
  GetBucketReferer 操作用于查看bucket的Referer相关配置。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_referer("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "RefererConfiguration" => %{
            "AllowEmptyReferer" => "true",
            "RefererList" => nil
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
  """

  @spec get_bucket_referer(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_referer(bucket) do
    get_bucket(bucket, %{}, %{"referer" => nil})
  end

  @doc """
  GetBucketLifecycle 用于查看Bucket的Lifecycle配置。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_lifecycle("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "LifecycleConfiguration" => %{
            "Rule" => %{
              "ID" => "delete after one day",
              "Prefix" => "logs/",
              "Status" => "Enabled",
              "Expiration" => %{
                "Days" => "1"
              }
            }
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
  """
  @spec get_bucket_lifecycle(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_lifecycle(bucket) do
    get_bucket(bucket, %{}, %{"lifecycle" => nil})
  end

  @doc """
  GetBucketEncryption 用于获取Bucket加密规则。

  ## Examples

      iex> Aliyun.Oss.Bucket.get_bucket_encryption("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "ServerSideEncryptionRule" => %{
            "ApplyServerSideEncryptionByDefault" => %{
              "SSEAlgorithm" => "AES256"
            }
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
  """
  @spec get_bucket_encryption(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_bucket_encryption(bucket) do
    get_bucket(bucket, %{}, %{"encryption" => nil})
  end

  @doc """
  PutBucket接口用于创建 Bucket

  ## Examples

      iex> Aliyun.Oss.Bucket.put_bucket("new-bucket", %{"x-oss-acl" => "private"})
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
      iex> Aliyun.Oss.Bucket.put_bucket("new-bucket", %{"x-oss-acl" => "invalid-permission"}) # get error
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

    注：所有 PutBucketXXX 相关操作亦可由此接口实现, 即 Bucket.put_bucket_acl("some-bucket", "private") 等同于 Bucket.put_bucket("some-bucket", %{"x-oss-acl" => "private"}, %{"acl" => "private"}, "")
  """
  @body """
  <?xml version="1.0" encoding="UTF-8"?>
  <CreateBucketConfiguration>
    <StorageClass>Standard</StorageClass>
  </CreateBucketConfiguration>
  """
  @spec put_bucket(String.t(), map(), map(), String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put_bucket(bucket, headers = %{} \\ %{}, sub_resources = %{} \\ %{}, body \\ @body) when is_binary(body) do
    Service.put(bucket, nil, body, headers: headers, sub_resources: sub_resources)
  end

  @doc """
  PutBucketACL接口用于修改Bucket访问权限

  ## Examples

      iex> Aliyun.Oss.Bucket.put_bucket_acl("some-bucket", "public-read")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 04:43:42 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"Location", "/some-bucket"},
          {"x-oss-server-time", "333"}
        ]
      }}
      iex> Aliyun.Oss.Bucket.put_bucket_acl("some-bucket", "invalid-permission")
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "ArgumentName" => "x-oss-acl",
          "ArgumentValue" => "invalid-read",
          "Code" => "InvalidArgument",
          "HostId" => "some-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "no such bucket access control exists",
          "RequestId" => "5C3000000000000000000000"
        },
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>",
        status_code: 400
      }}
  """
  @spec put_bucket_acl(String.t(), String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put_bucket_acl(bucket, acl) do
    put_bucket(bucket, %{"x-oss-acl" => acl}, %{"acl" => acl}, "")
  end

  @doc """
  PutBucketLogging接口用于为 Bucket 开启访问日志记录功能。

  ## Examples

      iex> Aliyun.Oss.Bucket.put_bucket_logging("some-bucket", "target-bucket", "target-prefix")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:05:50 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"x-oss-server-time", "63"}
        ]
      }}
  """

  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <BucketLoggingStatus>
    <LoggingEnabled>
      <TargetBucket><%= target_bucket %></TargetBucket>
      <TargetPrefix><%= target_prefix %></TargetPrefix>
    </LoggingEnabled>
  </BucketLoggingStatus>
  """
  @spec put_bucket_logging(String.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put_bucket_logging(bucket, target_bucket, target_prefix \\ "oss-accesslog/") do
    body = EEx.eval_string(
      @body_tmpl,
      [target_bucket: target_bucket, target_prefix: target_prefix]
    )
    put_bucket(bucket, %{}, %{"logging" => nil}, body)
  end

  @doc """
  PutBucketWebsite接口用于将一个bucket设置成静态网站托管模式，以及设置跳转规则。

  ## Examples

      iex> xml_body = \"""
      ...> <?xml version="1.0" encoding="UTF-8"?>
      ...> <WebsiteConfiguration>
      ...> <IndexDocument>
      ...>   <Suffix>index.html</Suffix>
      ...> </IndexDocument>
      ...> ...
      ...> ...
      ...> </WebsiteConfiguration>
      ...>  \"""
      iex> Aliyun.Oss.Bucket.put_bucket_website("some-bucket", xml_body)
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:05:50 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"x-oss-server-time", "63"}
        ]
      }}
  """
  @spec put_bucket_website(String.t(), String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put_bucket_website(bucket, xml_body) do
    put_bucket(bucket, %{}, %{"website" => nil}, xml_body)
  end

  @doc """
  PutBucketReferer接口用于设置Bucket的Referer访问白名单以及允许Referer字段是否为空。

  ## Examples

      iex> xml_body = \"""
      ...> <?xml version="1.0" encoding="UTF-8"?>
      ...> <RefererConfiguration>
      ...> <AllowEmptyReferer>true</AllowEmptyReferer >
      ...>     <RefererList>
      ...>         <Referer> http://www.aliyun.com</Referer>
      ...>         <Referer> https://www.aliyun.com</Referer>
      ...>         <Referer> http://www.*.com</Referer>
      ...>         <Referer> https://www.?.aliyuncs.com</Referer>
      ...>     </RefererList>
      ...> </RefererConfiguration>
      ...>  \"""
      iex> Aliyun.Oss.Bucket.put_bucket_referer("some-bucket", xml_body)
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:05:50 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"x-oss-server-time", "63"}
        ]
      }}
  """
  @spec put_bucket_referer(String.t(), String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put_bucket_referer(bucket, xml_body) do
    put_bucket(bucket, %{}, %{"referer" => nil}, xml_body)
  end

  @doc """
  PutBucketEncryption接口用于配置Bucket的加密规则。

  ## Options

    - `:algorithm` - Accept value: `:aes256`, `:kms`, default is `:aes256`
    - `:kms_master_key_id` - Should and only be set if algorithm is `:kms`

  ## Examples

      iex> Aliyun.Oss.Bucket.put_bucket_encryption("some-bucket", algorithm: :aes256)
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:05:50 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"x-oss-server-time", "63"}
        ]
      }}
  """
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <ServerSideEncryptionRule>
    <ApplyServerSideEncryptionByDefault>
      <SSEAlgorithm><%= algorithm %></SSEAlgorithm>
      <KMSMasterKeyID><%= kms_master_key_id %></KMSMasterKeyID>
    </ApplyServerSideEncryptionByDefault>
  </ServerSideEncryptionRule>
  """
  @spec put_bucket_encryption(String.t(), Keyword.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put_bucket_encryption(bucket, opts \\ []) do
    {algorithm, kms_master_key_id} =
      case Keyword.get(opts, :algorithm, :aes256) do
        :aes256 -> {"AES256", nil}
        :kms -> {"KMS", Keyword.fetch!(opts, :kms_master_key_id)}
      end

    xml_body = EEx.eval_string(
      @body_tmpl,
      [algorithm: algorithm, kms_master_key_id: kms_master_key_id]
    )
    put_bucket(bucket, %{}, %{"encryption" => nil}, xml_body)
  end

  @doc """
  DeleteBucket用于删除某个Bucket

  ## Examples

      iex> Aliyun.Oss.Bucket.delete_bucket("some-bucket")
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
      iex> Aliyun.Oss.Bucket.delete_bucket("unknown-bucket")
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

    注：所有 DeleteBucketXXX 相关操作亦可由此接口实现, 即 Bucket.delete_bucket_logging("some-bucket") 等同于 Bucket.delete_bucket("some-bucket", %{"logging" => nil})
  """
  @spec delete_bucket(String.t(), map()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete_bucket(bucket, sub_resources \\ %{}) do
    Service.delete(bucket, nil, sub_resources: sub_resources)
  end

  @doc """
  DeleteBucketLogging接口用于关闭bucket访问日志记录功能

  ## Examples

      iex> Aliyun.Oss.Bucket.delete_bucket_logging("some-bucket")
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
      iex> Aliyun.Oss.Bucket.delete_bucket_logging("unknown-bucket")
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "BucketName" => "unknown-bucket",
          "Code" => "NoSuchBucket",
          "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "The specified bucket does not exist.",
          "RequestId" => "5C38283EC84D1C4471F2F48A"
        },
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>",
        status_code: 404
      }}
  """
  @spec delete_bucket_logging(String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete_bucket_logging(bucket) do
    delete_bucket(bucket, %{"logging" => nil})
  end

  @doc """
  DeleteBucketWebsite操作用于关闭Bucket的静态网站托管模式以及跳转规则。

  ## Examples

      iex> Aliyun.Oss.Bucket.delete_bucket_website("some-bucket")
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
      iex> Aliyun.Oss.Bucket.delete_bucket_website("unknown-bucket")
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "BucketName" => "unknown-bucket",
          "Code" => "NoSuchBucket",
          "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "The specified bucket does not exist.",
          "RequestId" => "5C38283EC84D1C4471F2F48A"
        },
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>",
        status_code: 404
      }}
  """
  @spec delete_bucket_website(String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete_bucket_website(bucket) do
    delete_bucket(bucket, %{"website" => nil})
  end

  @doc """
  通过DeleteBucketLifecycle接口来删除指定 Bucket 的生命周期规则。

  ## Examples

      iex> Aliyun.Oss.Bucket.delete_bucket_lifecycle("some-bucket")
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
      iex> Aliyun.Oss.Bucket.delete_bucket_lifecycle("unknown-bucket")
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "BucketName" => "unknown-bucket",
          "Code" => "NoSuchBucket",
          "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "The specified bucket does not exist.",
          "RequestId" => "5C38283EC84D1C4471F2F48A"
        },
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>",
        status_code: 404
      }}
  """
  @spec delete_bucket_lifecycle(String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete_bucket_lifecycle(bucket) do
    delete_bucket(bucket, %{"lifecycle" => nil})
  end

  @doc """
  DeleteBucketEncryption接口用于删除Bucket加密规则。

  ## Examples

      iex> Aliyun.Oss.Bucket.delete_bucket_encryption("some-bucket")
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
  @spec delete_bucket_encryption(String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete_bucket_encryption(bucket) do
    delete_bucket(bucket, %{"encryption" => nil})
  end
end
