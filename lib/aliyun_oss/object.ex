defmodule Aliyun.Oss.Object do
  @moduledoc """
  Object operations - basic operations.

  Other operations can be found in:

  - `Aliyun.Oss.Object`
  - `Aliyun.Oss.Object.MultipartUpload`
  - `Aliyun.Oss.Object.ACL`
  - `Aliyun.Oss.Object.Symlink`
  - `Aliyun.Oss.Object.Tagging`

  """

  alias Aliyun.Oss.{Config, Service, Sign}
  alias Aliyun.Oss.Client.{Request, Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  HeadObject - gets the metadata of an object.

  The content of the object is not returned.

  ## Options

  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Object.head_object(config, "some-bucket", "some-object")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "accept-ranges" => ["bytes"],
          "connection" => ["keep-alive"],
          "content-length" => ["19"],
          "content-md5" => ["wpqajJtzJSpf8lOY/W4Hqg=="],
          "content-type" => ["text/plain"],
          "date" => ["Fri, 04 Jul 2025 03:10:24 GMT"],
          "etag" => ["\"D4100000000000000000000000000000\""],
          "last-modified" => ["Fri, 15 Jan 2021 09:16:13 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-hash-crc64ecma" => ["587015626014620604"],
          "x-oss-object-type" => ["Normal"],
          "x-oss-request-id" => ["680000000000000000000CE1"],
          "x-oss-server-time" => ["24"],
          "x-oss-storage-class" => ["Standard"],
          "x-oss-version-id" => ["null"]
        }
      }}

      iex> Aliyun.Oss.Object.head_object(config, "some-bucket", "unknown-object")
      {:error, %Aliyun.Oss.Client.Error{status_code: 404, body: "", parsed_details: nil}}

  """
  @spec head_object(Config.t(), String.t(), String.t(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def head_object(%Config{} = config, bucket, object, options \\ []) do
    Service.head(config, bucket, object, options)
  end

  @doc """
  GetObjectMeta - gets the metadata of an object, including ETag, Size, and LastModified.

  The content of the object is not returned.

  ## Examples

      iex> Aliyun.Oss.Object.get_object_meta(config, "some-bucket", "some-object")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["19"],
          "date" => ["Fri, 04 Jul 2025 03:16:45 GMT"],
          "etag" => ["\"D4100000000000000000000000000000\""],
          "last-modified" => ["Fri, 15 Jan 2021 09:16:13 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-hash-crc64ecma" => ["587015626014620604"],
          "x-oss-request-id" => ["680000000000000000000F52"],
          "x-oss-server-time" => ["39"],
          "x-oss-version-id" => ["null"]
        }
      }}

  """
  @spec get_object_meta(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_object_meta(%Config{} = config, bucket, object) do
    Service.head(config, bucket, object, query_params: %{"objectMeta" => nil})
  end

  @doc """
  GetObject - gets an object.

  ## Options

  - `:query_params` - Defaults to `%{}`
  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Object.get_object(config, "some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: <<208, 207, 17, 224, 161, 177, 26, 225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 62, 0, 3, 0, 254, 255, 9, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18,
            0, 0, 0, ...>>,
          headers: %{
            "accept-ranges" => ["bytes"],
            "connection" => ["keep-alive"],
            "content-md5" => ["wpqajJtzJSpf8lOY/W4Hqg=="],
            "content-type" => ["text/plain"],
            "date" => ["Fri, 04 Jul 2025 05:45:44 GMT"],
            "etag" => ["\"C29000000000000000000000000000AA\""],
            "last-modified" => ["Fri, 15 Jan 2021 09:16:13 GMT"],
            "server" => ["AliyunOSS"],
            "x-oss-hash-crc64ecma" => ["587015626014620604"],
            "x-oss-object-type" => ["Normal"],
            "x-oss-request-id" => ["6860000000000000000000A3"],
            "x-oss-server-time" => ["41"],
            "x-oss-storage-class" => ["Standard"],
            "x-oss-version-id" => ["null"]
          }
        }
      }
      iex> Aliyun.Oss.Object.get_object(config, "some-bucket", "some-object", headers: %{}, query_params: %{"response-cache-control" => "no-cache"})
      {:ok, %Aliyun.Oss.Client.Response{
          data: <<208, 207, 17, 224, 161, 177, 26, 225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 62, 0, 3, 0, 254, 255, 9, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18,
            0, 0, 0, ...>>,
          headers: %{
            "accept-ranges" => ["bytes"],
            "cache-control" => ["no-cache],
            "connection" => ["keep-alive"],
            "content-md5" => ["wpqajJtzJSpf8lOY/W4Hqg=="],
            "content-type" => ["text/plain"],
            "date" => ["Fri, 04 Jul 2025 05:45:44 GMT"],
            "etag" => ["\"C29000000000000000000000000000AA\""],
            "last-modified" => ["Fri, 15 Jan 2021 09:16:13 GMT"],
            "server" => ["AliyunOSS"],
            "x-oss-hash-crc64ecma" => ["587015626014620604"],
            "x-oss-object-type" => ["Normal"],
            "x-oss-request-id" => ["6860000000000000000000A3"],
            "x-oss-server-time" => ["41"],
            "x-oss-storage-class" => ["Standard"],
            "x-oss-version-id" => ["null"]
          }
        }
      }
      iex> Aliyun.Oss.Object.get_object(config, "some-bucket", "some-object", headers: %{"range" => "bytes=0-2"}, query_params: %{"response-cache-control" => "no-cache"})
      {:ok, %Aliyun.Oss.Client.Response{
          data: "abc",
          headers: %{
            "accept-ranges" => ["bytes"],
            "cache-control" => ["no-cache],
            "connection" => ["keep-alive"],
            "content-md5" => ["wpqajJtzJSpf8lOY/W4Hqg=="],
            "content-type" => ["text/plain"],
            "date" => ["Fri, 04 Jul 2025 05:45:44 GMT"],
            "etag" => ["\"C29000000000000000000000000000AA\""],
            "last-modified" => ["Fri, 15 Jan 2021 09:16:13 GMT"],
            "server" => ["AliyunOSS"],
            "x-oss-hash-crc64ecma" => ["587015626014620604"],
            "x-oss-object-type" => ["Normal"],
            "x-oss-request-id" => ["6860000000000000000000A3"],
            "x-oss-server-time" => ["41"],
            "x-oss-storage-class" => ["Standard"],
            "x-oss-version-id" => ["null"]
          }
        }
      }

  """
  @spec get_object(Config.t(), String.t(), String.t(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_object(%Config{} = config, bucket, object, options \\ []) do
    Service.get(config, bucket, object, options)
  end

  @doc """
  SelectObject - executes SQL statements to perform operations on an object and obtains the execution results.

  ## Options

  - `:format` - specifies the request syntax:
      - available values: `:json`, `:csv`
      - default value: `:csv`

  ## Examples

      iex> select_request = %{
        "SelectRequest" => %{
          "Expression" => "c2VsZWN0ICogZnJvbSBvc3NvYmplY3Q=",
          "InputSerialization" => %{"JSON" => %{"Type" => "DOCUMENT"}},
          "OutputSerialization" => %{"JSON" => %{"RecordDelimiter" => "LA=="}}
        }
      }
      iex> Aliyun.Oss.Object.select_object(config, "some-bucket", "file.json", select_request, format: :json)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"contacts" => [...]},
          headers: %{
            "accept-ranges" => ["bytes"],
            "connection" => ["keep-alive"],
            ...
          }
        }
      }
      iex> select_request = ~S[
        <SelectRequest>
            <Expression>c2VsZWN0ICogZnJvbSBvc3NvYmplY3Q=</Expression>
            <InputSerialization>
            <JSON>
                <Type>DOCUMENT</Type>
            </JSON>
            </InputSerialization>
            <OutputSerialization>
            <JSON>
                <RecordDelimiter>LA==</RecordDelimiter>
            </JSON>
            </OutputSerialization>
        </SelectRequest>
      ]
      iex> Aliyun.Oss.Object.select_object(config, "some-bucket", "file.json", select_request, format: :json)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"contacts" => [...]},
          headers: %{
            "accept-ranges" => ["bytes"],
            "connection" => ["keep-alive"],
            ...
          }
        }
      }
      iex> select_request = %{
        "SelectRequest" => %{"Expression" => "c2VsZWN0ICogZnJvbSBvc3NvYmplY3Q="}
      }
      iex> Aliyun.Oss.Object.select_object(config, "some-bucket", "file.csv", select_request, format: :csv)
      {:ok, %Aliyun.Oss.Client.Response{
          data: "...",
          headers: %{
            "accept-ranges" => ["bytes"],
            "connection" => ["keep-alive"],
            ...
          }
        }
      }
      iex> select_request = ~S[
        <SelectRequest>
          <Expression>c2VsZWN0ICogZnJvbSBvc3NvYmplY3Q=</Expression>
        </SelectRequest>
      ]
      iex> Aliyun.Oss.Object.select_object(config, "some-bucket", "file.csv", select_request, format: :csv)
      {:ok, %Aliyun.Oss.Client.Response{
          data: "...",
          headers: %{
            "accept-ranges" => ["bytes"],
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

  """
  @spec select_object(Config.t(), String.t(), String.t(), String.t() | map(), keyword) ::
          {:error, error()} | {:ok, Response.t()}
  def select_object(config, bucket, object, select_request, options \\ [])

  def select_object(config, bucket, object, %{} = select_request, options) do
    select_object(config, bucket, object, MapToXml.from_map(select_request), options)
  end

  def select_object(config, bucket, object, select_request, options) do
    x_oss_process =
      case Keyword.get(options, :format, :csv) do
        :csv -> "csv/select"
        :json -> "json/select"
      end

    post_object(config, bucket, object, select_request,
      query_params: %{"x-oss-process" => x_oss_process}
    )
  end

  @doc """
  CreateSelectObjectMeta - 获取目标文件总的行数，总的列数（对于 CSV 文件），以及 Splits 个数。

  如果该信息不存在，则会扫描整个文件，分析并记录下 CSV 文件的上述信息。重复调用则会保存上述信息而不必重新扫描整个文件。

  TODO: fix the doc

  ## Options

  - `:format` - specifies the request syntax:
      - available values: `:json`, `:csv`
      - default value: `:csv`

  ## Examples

      iex> select_request = %{
        "JsonMetaRequest" => %{
          "InputSerialization" => %{"JSON" => %{"Type" => "LINES"}},
          "OverwriteIfExisting" => "false"
        }
      }
      iex> Aliyun.Oss.Object.select_object_meta(config, "some-bucket", "some-object", select_request, format: :json)
      {:ok, %Aliyun.Oss.Client.Response{
          data: <<208, 207, 17, 224, 161, 177, 26, 225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 62, 0, 3, 0, 254, 255, 9, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18,
            0, 0, 0, ...>>,
          headers: %{
            "accept-ranges" => ["bytes"],
            "connection" => ["keep-alive"],
            ...
          }
        }
      }
      iex> select_request = ~S[
        <?xml version="1.0"?>
        <JsonMetaRequest>
            <InputSerialization>
                <JSON>
                    <Type>LINES</Type>
                </JSON>
            </InputSerialization>
            <OverwriteIfExisting>false</OverwriteIfExisting>
        </JsonMetaRequest>
      ]
      iex> Aliyun.Oss.Object.select_object_meta(config, "some-bucket", "some-object", select_request, format: :json)
      {:ok, %Aliyun.Oss.Client.Response{
          data: <<208, 207, 17, 224, 161, 177, 26, 225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 62, 0, 3, 0, 254, 255, 9, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18,
            0, 0, 0, ...>>,
          headers: %{
            "accept-ranges" => ["bytes"],
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

  """
  @spec select_object_meta(Config.t(), String.t(), String.t(), String.t() | map(), keyword) ::
          {:error, error()} | {:ok, Response.t()}
  def select_object_meta(config, bucket, object, select_request, options \\ [])

  def select_object_meta(config, bucket, object, %{} = select_request, options) do
    select_object_meta(config, bucket, object, MapToXml.from_map(select_request), options)
  end

  def select_object_meta(config, bucket, object, select_request, options) do
    x_oss_process =
      case Keyword.get(options, :format, :csv) do
        :csv -> "csv/meta"
        :json -> "json/meta"
      end

    post_object(config, bucket, object, select_request,
      query_params: %{"x-oss-process" => x_oss_process}
    )
  end

  @doc """
  Creates a signed URL for an object.

  ## Options

  - `:query_params` - Defaults to `%{}`
  - `:headers` - Defaults to `%{}`
  - `:method` - HTTP method to use for the signed URL, defaults to `:get`, accept values: `:get`, `:put`, `:post`, `:delete`, `:head`
  - `:expires` - number of seconds until the signed URL expires, defaults to 3600 seconds (1 hour)

  ## Examples

      iex> expires = 3600
      iex> Aliyun.Oss.Object.signed_url(config, "some-bucket", "some-object", expires: expires, method: :get)
      "https://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?x-oss-credential=LT**************%2F20250701%2Fcn-hangzhou%2Foss%2Faliyun_v4_request&x-oss-date=20250701T070913Z&x-oss-expires=3600&x-oss-signature=2f64d***********************************************************&x-oss-signature-version=OSS4-HMAC-SHA256"
      iex> Aliyun.Oss.Object.signed_url(config, "some-bucket", "some-object", expires: expires, method: :put, headers: %{"Content-Type" => "text/plain"})
      "https://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?x-oss-credential=LT**************%2F20250701%2Fcn-hangzhou%2Foss%2Faliyun_v4_request&x-oss-date=20250701T070944Z&x-oss-expires=3600&x-oss-signature=2a6e************************************************************&x-oss-signature-version=OSS4-HMAC-SHA256"

  """
  @spec signed_url(Config.t(), String.t(), String.t(), keyword()) ::
          String.t()
  def signed_url(config, bucket, object, options \\ []) do
    Request.build!(
      config,
      Keyword.get(options, :method, :get),
      bucket,
      object,
      Keyword.get(options, :headers, %{}),
      Keyword.get(options, :query_params, %{}),
      ""
    )
    |> Request.sign_url(Keyword.get(options, :expires, 3600))
    |> Request.to_url()
  end

  @doc """
  Creates a signed URL for accessing an object.

  ## Examples

      iex> expires = 3600
      iex> Aliyun.Oss.Object.object_url(config, "some-bucket", "some-object", expires)
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc56s936**9l&Expires=1141889120&Signature=vjbyPxybdZaNmGa%2ByT272YEAiv4%3D"

  """
  @spec object_url(Config.t(), String.t(), String.t(), integer()) :: String.t()
  def object_url(config, bucket, object, expires) do
    signed_url(config, bucket, object, expires: expires, method: :get)
  end

  @doc """
  PutObject - uploads objects.

  ## Options

  - `:query_params` - Defaults to `%{}`
  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Object.put_object(config, "some-bucket", "some-object", "CONTENT")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            "content-length" => ["0"],
            "content-md5" => ["plz3uTkI****************"],
            "date" => ["Fri, 11 Jul 2025 02:30:40 GMT"],
            "etag" => ["\"A65CF7B93908B3A*****************\""],
            "server" => ["AliyunOSS"],
            "x-oss-hash-crc64ecma" => ["162113910***********"],
            "x-oss-request-id" => ["687077508A8E************"],
            "x-oss-server-time" => ["107"]
          }
        }
      }

  """
  @spec put_object(Config.t(), String.t(), String.t(), String.t(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def put_object(config, bucket, object, body, options \\ []) do
    Service.put(config, bucket, object, body, options)
  end

  @doc """
  CopyObject - copies objects within a bucket or between buckets in the same region.

  ## Options

  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Object.copy_object(config, {"source-bucket", "source-object"}, {"target-bucket", "target-object"})
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CopyObjectResult" => %{
              "ETag" => "\"D2D5****************************\"",
              "LastModified" => "2025-02-27T09:21:13.000Z"
            }
          },
          headers: %{
            "connection" => ["keep-alive"],
            "content-type" => ["application/xml"],
            "date" => ["Fri, 11 Jul 2025 02:35:21 GMT"],
            "etag" => ["\"A65CF7B9************************\""],
            "server" => ["AliyunOSS"],
            "x-oss-copied-size" => ["20"],
            "x-oss-hash-crc64ecma" => ["16211***************"],
            "x-oss-ia-retrieve-flow-type" => ["0"],
            "x-oss-request-id" => ["68707869D***************"],
            "x-oss-server-time" => ["71"],
            "x-oss-version-id" => ["null"]
          }
        }
      }

  """
  @spec copy_object(Config.t(), {String.t(), String.t()}, {String.t(), String.t()}, keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def copy_object(
        config,
        {source_bucket, source_object},
        {target_bucket, target_object},
        options \\ []
      ) do
    headers = %{"x-oss-copy-source" => "/#{source_bucket}/#{source_object}"}
    options = Keyword.update(options, :headers, headers, &Map.merge(&1, headers))
    put_object(config, target_bucket, target_object, "", options)
  end

  @doc """
  AppendObject - uploads an object by appending the content of the object to an existing object.

  ## Examples

      iex> Aliyun.Oss.Object.append_object(config, "some-bucket", "some-object", "CONTENT", 0)
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            "content-length" => ["0"],
            "date" => ["Fri, 11 Jul 2025 02:46:19 GMT"],
            "etag" => ["\"AE9A6C899***********************\""],
            "server" => ["AliyunOSS"],
            "x-oss-hash-crc64ecma" => ["178569**************"],
            "x-oss-next-append-position" => ["7"],
            "x-oss-request-id" => ["68707AFB****************"],
            "x-oss-server-time" => ["15"]
          }
        }
      }

  """
  @spec append_object(Config.t(), String.t(), String.t(), String.t(), integer(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def append_object(config, bucket, object, content, position, options \\ []) do
    query_params = %{"append" => nil, "position" => position}
    options = Keyword.update(options, :query_params, query_params, &Map.merge(&1, query_params))
    post_object(config, bucket, object, content, options)
  end

  @doc """
  RestoreObject - restores an Archive object or a Cold Archive object.

  ## Examples

      iex> Aliyun.Oss.Object.restore_object(config, "some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            "content-length" => ["0"],
            "date" => ["Fri, 11 Jul 2025 03:13:57 GMT"],
            "server" => ["AliyunOSS"],
            "x-oss-request-id" => ["68708175A***************"],
            "x-oss-server-time" => ["6"]
          }
        }
      }

  """
  @spec restore_object(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def restore_object(config, bucket, object) do
    post_object(config, bucket, object, "", query_params: %{"restore" => nil})
  end

  @doc """
  CleanRestoredObject

  ## Examples

      iex> Aliyun.Oss.Object.clean_restored_object(config, "some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            "content-length" => ["0"],
            "date" => ["Fri, 11 Jul 2025 03:13:57 GMT"],
            "server" => ["AliyunOSS"],
            "x-oss-request-id" => ["68708175A***************"],
            "x-oss-server-time" => ["6"]
          }
        }
      }

  """
  @spec clean_restored_object(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def clean_restored_object(config, bucket, object) do
    post_object(config, bucket, object, "", query_params: %{"cleanRestoredObject" => nil})
  end

  @doc """
  DeleteObject - deletes an object.

  ## Options

  - `:query_params` - Defaults to `%{}`
  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Object.delete_object(config, "some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            "content-length" => ["0"],
            ...
          }
        }
      }

  """
  @spec delete_object(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def delete_object(config, bucket, object, options \\ []) do
    Service.delete(config, bucket, object, options)
  end

  @doc """
  DeleteMultipleObjects - deletes multiple objects from a bucket.

  ## Options

  - `:encoding_type` - Accept value: `:url`
  - `:quiet` - Set `true` to enable the quiet mode, default is `false`. This option will be ignored if you pass the raw xml body as the 3rd argument.

  ## Examples

      iex> Aliyun.Oss.Object.delete_multiple_objects(config, "some-bucket", ["object1", "object2"])
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "DeleteResult" => %{
              "Deleted" => [
                %{"Key" => "object1"},
                %{"Key" => "object2"}
              ]
            }
          },
          headers: %{
            "connection" => ["keep-alive"],
            "content-type" => ["application/xml"],
            ...
          }
        }
      }
      iex> xml_body = ~S[
      <?xml version="1.0" encoding="UTF-8"?>
      <Delete>
        <Quiet>false</Quiet>
        <Object>
          <Key>multipart.data</Key>
          <VersionId>CAEQNRiBgIDyz.6C0BYiIGQ2NWEwNmVhNTA3ZTQ3MzM5ODliYjM1ZTdjYjA4****</VersionId>
        </Object>
      </Delete>
      ]
      iex> Aliyun.Oss.Object.delete_multiple_objects(config, "some-bucket", xml_body)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "DeleteResult" => %{
              "Deleted" => [
                %{
                  "Key" => "multipart.data",
                  "VersionId" => "CAEQNRiBgIDyz.6C0BYiIGQ2NWEwNmVhNTA3ZTQ3MzM5ODliYjM1ZTdjYjA4****"
                },
              ]
            }
          },
          headers: %{
            "connection" => ["keep-alive"],
            "content-type" => ["application/xml"],
            ...
          }
        }
      }
  """
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <Delete>
    <Quiet><%= quiet %></Quiet>
    <%= for object <- objects do %>
      <Object><Key><%= object %></Key></Object>
    <% end %>
  </Delete>
  """
  @spec delete_multiple_objects(Config.t(), String.t(), [String.t()] | String.t(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def delete_multiple_objects(config, bucket, objects_or_xml_body, options \\ [])

  def delete_multiple_objects(config, bucket, objects, options) when is_list(objects) do
    quiet = Keyword.get(options, :quiet, false)
    body = EEx.eval_string(@body_tmpl, quiet: quiet, objects: objects)
    delete_multiple_objects(config, bucket, body, options)
  end

  def delete_multiple_objects(config, bucket, body, options) when is_binary(body) do
    headers =
      case Keyword.get(options, :encoding_type) do
        :url -> %{"encoding-type" => "url"}
        _ -> %{}
      end
      |> Map.put("content-length", String.length(body))
      |> Map.put("content-md5", :md5 |> :crypto.hash(body) |> Base.encode64())

    Service.post(config, bucket, nil, body, headers: headers, query_params: %{"delete" => nil})
  end

  @doc """
  Signs Post Policy, and returns the encoded Post Policy and its signature.

  ## Examples

      iex> policy = %{
      ...>  "conditions" => [
      ...>    ["content-length-range", 0, 10485760],
      ...>    %{"bucket" => "ahaha"},
      ...>    %{"A" => "a"},
      ...>    %{"key" => "ABC"}
      ...>  ],
      ...>  "expiration" => "2013-12-01T12:00:00Z"
      ...>}
      iex> Aliyun.Oss.Object.sign_post_policy(config, policy)
      %{
        policy: "eyJjb25kaXRpb25zIjpbWyJjb250ZW50LWxlbmd0aC1yYW5nZSIsMCwxMDQ4NTc2MF0seyJidWNrZXQiOiJhaGFoYSJ9LHsiQSI6ImEifSx7ImtleSI6IkFCQyJ9XSwiZXhwaXJhdGlvbiI6IjIwMTMtMTItMDFUMTI6MDA6MDBaIn0=",
        signature: "d9ea2e7088a5a7189d2d1a84aa872a00b7078877ffbd4a24b8897c23f16bc1db"
      }

  """
  @spec sign_post_policy(Config.t(), map()) :: %{
          policy: String.t(),
          signature: String.t()
        }
  def sign_post_policy(config, %{} = policy) do
    today = Date.utc_today() |> Date.to_iso8601(:basic)
    encoded_policy = policy |> JSON.encode!() |> Base.encode64()

    %{
      policy: encoded_policy,
      signature: Sign.sign(encoded_policy, Sign.get_signing_key(config, today))
    }
  end

  @spec post_object(Config.t(), String.t(), String.t(), String.t(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def post_object(config, bucket, object, body, options) do
    Service.post(config, bucket, object, body, options)
  end
end
