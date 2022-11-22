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

  alias Aliyun.Oss.ConfigAlt, as: Config
  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.{Request, Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  HeadObject - gets the metadata of an object.

  The content of the object is not returned.

  ## Examples

      iex> Aliyun.Oss.Object.head_object(config, "some-bucket", "some-object")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Wed, 05 Dec 2018 05:50:02 GMT"},
          {"Content-Type", "application/octet-stream"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"Accept-Ranges", "bytes"},
          {"ETag", "\"D4100000000000000000000000000000\""},
          {"Last-Modified", "Mon, 15 Oct 2018 01:38:47 GMT"},
          {"x-oss-object-type", "Normal"},
          {"x-oss-hash-crc64ecma", "0"},
          {"x-oss-storage-class", "IA"},
          {"Content-MD5", "1B2M2Y8AsgTpgAmY7PhCfg=="},
          {"x-oss-server-time", "19"}
        ]
      }}

      iex> Aliyun.Oss.Object.head_object(config, "some-bucket", "unknown-object")
      {:error, %Aliyun.Oss.Client.Error{status_code: 404, body: "", parsed_details: nil}}

  """
  @spec head_object(Config.t(), String.t(), String.t(), map(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def head_object(%Config{} = config, bucket, object, headers \\ %{}, sub_resources \\ %{}) do
    Service.head(config, bucket, object, headers: headers, sub_resources: sub_resources)
  end

  @doc """
  GetObjectMeta - gets the metadata of an object, including ETag, Size, and LastModified.

  The content of the object is not returned.

  ## Examples

      iex> Aliyun.Oss.Object.get_object_meta(config, "some-bucket", "some-object")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Wed, 05 Dec 2018 05:50:02 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"ETag", "\"D4100000000000000000000000000000\""},
          {"x-oss-hash-crc64ecma", "0"},
          {"Last-Modified", "Mon, 15 Oct 2018 01:38:47 GMT"},
          {"x-oss-server-time", "19"}
        ]
      }}

  """
  @spec get_object_meta(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_object_meta(%Config{} = config, bucket, object) do
    head_object(config, bucket, object, %{}, %{"objectMeta" => nil})
  end

  @doc """
  GetObject - gets an object.

  ## Examples

      iex> Aliyun.Oss.Object.get_object(config, "some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: <<208, 207, 17, 224, 161, 177, 26, 225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 62, 0, 3, 0, 254, 255, 9, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18,
            0, 0, 0, ...>>,
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }

  """
  @spec get_object(Config.t(), String.t(), String.t(), map(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_object(%Config{} = config, bucket, object, headers \\ %{}, sub_resources \\ %{}) do
    Service.get(config, bucket, object, headers: headers, sub_resources: sub_resources)
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
          "Expression" => "c2VsZWN0ICogZnJvbSBvc3NvYmplY3QuY29udGFjdHNbKl0gcyB3aGVyZSBzLmFnZSA9IDI3",
          "InputSerialization" => %{"JSON" => %{"Type" => "DOCUMENT"}},
          "OutputSerialization" => %{"JSON" => %{"RecordDelimiter" => "LA=="}}
        }
      }
      iex> Aliyun.Oss.Object.select_object(config, "some-bucket", "some-object", select_request, format: :json)
      {:ok, %Aliyun.Oss.Client.Response{
          data: <<208, 207, 17, 224, 161, 177, 26, 225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 62, 0, 3, 0, 254, 255, 9, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18,
            0, 0, 0, ...>>,
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
      iex> select_request = ~S[
        <SelectRequest>
            <Expression>c2VsZWN0ICogZnJvbSBvc3NvYmplY3QuY29udGFjdHNbKl0gcyB3aGVyZSBzLmFnZSA9IDI3</Expression>
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
      iex> Aliyun.Oss.Object.select_object(config, "some-bucket", "some-object", select_request, format: :json)
      {:ok, %Aliyun.Oss.Client.Response{
          data: <<208, 207, 17, 224, 161, 177, 26, 225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 62, 0, 3, 0, 254, 255, 9, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18,
            0, 0, 0, ...>>,
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
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

    post_object(config, bucket, object, select_request, %{}, %{"x-oss-process" => x_oss_process})
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
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
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
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
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

    post_object(config, bucket, object, select_request, %{}, %{"x-oss-process" => x_oss_process})
  end

  @doc """
  Creates a signed URL for an object.

  ## Examples

      iex> expires = Timex.now() |> Timex.shift(days: 1) |> Timex.to_unix()
      iex> Aliyun.Oss.Object.signed_url(config, "some-bucket", "some-object", expires, "GET", %{"Content-Type" => ""})
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc5*******9l&Expires=1141889120&Signature=vjbyPxybdZ*****************v4%3D"
      iex> Aliyun.Oss.Object.signed_url(config, "some-bucket", "some-object", expires, "PUT", %{"Content-Type" => "text/plain"})
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc5*******9l&Expires=1141889120&Signature=vjbyPxybdZ*****************v4%3D"

  """
  @spec signed_url(Config.t(), String.t(), String.t(), integer(), String.t(), map(), map()) ::
          String.t()
  def signed_url(config, bucket, object, expires, method, headers, sub_resources \\ %{}) do
    request =
      Request.build(%{
        verb: method,
        host: "#{bucket}.#{config.endpoint}",
        path: "/#{object}",
        resource: "/#{bucket}/#{object}",
        sub_resources: sub_resources,
        headers: headers,
        expires: expires
      })

    Request.to_signed_url(config, request)
  end

  @doc """
  Creates a signed URL for accessing an object.

  ## Examples

      iex> expires = Timex.now() |> Timex.shift(days: 1) |> Timex.to_unix()
      iex> Aliyun.Oss.Object.object_url(config, "some-bucket", "some-object", expires)
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc56s936**9l&Expires=1141889120&Signature=vjbyPxybdZaNmGa%2ByT272YEAiv4%3D"

  """
  @spec object_url(Config.t(), String.t(), String.t(), integer()) :: String.t()
  def object_url(config, bucket, object, expires) do
    signed_url(config, bucket, object, expires, "GET", %{"Content-Type" => ""})
  end

  @doc """
  PutObject - uploads objects.

  ## Examples

      iex> Aliyun.Oss.Object.put_object(config, "some-bucket", "some-object", "CONTENT")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }

  """
  @spec put_object(Config.t(), String.t(), String.t(), String.t(), map(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def put_object(config, bucket, object, body, headers \\ %{}, sub_resources \\ %{}) do
    Service.put(config, bucket, object, body, headers: headers, sub_resources: sub_resources)
  end

  @doc """
  CopyObject - copies objects within a bucket or between buckets in the same region.

  ## Examples

      iex> Aliyun.Oss.Object.copy_object(config, {"source-bucket", "source-object"}, {"target-bucket", "target-object"})
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CopyObjectResult" => %{
              "ETag" => "\"D2D50000000000000000000000000000\"",
              "LastModified" => "2019-02-27T09:21:13.000Z"
            }
          },
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }

  """
  @spec copy_object(Config.t(), {String.t(), String.t()}, {String.t(), String.t()}, map()) ::
          {:error, error()} | {:ok, Response.t()}
  def copy_object(
        config,
        {source_bucket, source_object},
        {target_bucket, target_object},
        headers \\ %{}
      ) do
    headers = Map.put(headers, "x-oss-copy-source", "/#{source_bucket}/#{source_object}")
    put_object(config, target_bucket, target_object, "", headers)
  end

  @doc """
  AppendObject - uploads an object by appending the content of the object to an existing object.

  ## Examples

      iex> Aliyun.Oss.Object.append_object(config, "some-bucket", "some-object", "CONTENT", 0)
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Fri, 01 Mar 2019 05:57:23 GMT"},
            {"Content-Length", "0"},
            {"Connection", "keep-alive"},
            {"x-oss-request-id", "5C0000000000000000000000"},
            {"ETag", "\"B38D0000000000000000000000000000\""},
            {"x-oss-next-append-position", "10"},
            {"x-oss-hash-crc64ecma", "8000000000000000000"},
            {"x-oss-server-time", "17"}
          ]
        }
      }

  """
  @spec append_object(Config.t(), String.t(), String.t(), String.t(), integer(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def append_object(config, bucket, object, body, position, headers \\ %{}) do
    post_object(config, bucket, object, body, headers, %{"append" => nil, "position" => position})
  end

  @doc """
  RestoreObject - restores an Archive object or a Cold Archive object.

  ## Examples

      iex> Aliyun.Oss.Object.restore_object(config, "some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Fri, 01 Mar 2019 06:38:21 GMT"},
            {"Content-Length", "0"},
            {"Connection", "keep-alive"},
            {"x-oss-request-id", "5C7000000000000000000000"},
            {"x-oss-server-time", "7"}
          ]
        }
      }

  """
  @spec restore_object(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def restore_object(config, bucket, object) do
    post_object(config, bucket, object, "", %{}, %{"restore" => nil})
  end

  @doc """
  DeleteObject - deletes an object.

  ## Examples

      iex> Aliyun.Oss.Object.delete_object(config, "some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }

  """
  @spec delete_object(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def delete_object(config, bucket, object, sub_resources \\ %{}) do
    Service.delete(config, bucket, object, sub_resources: sub_resources)
  end

  @doc """
  DeleteMultipleObjects - deletes multiple objects from a bucket.

  ## Options

  - `:encoding_type` - Accept value: `:url`
  - `:quiet` - Set `true` to enable the quiet mode, default is `false`

  ## Examples

      iex> Aliyun.Oss.Object.delete_multiple_objects(config, "some-bucket", ["object1", "object2"])
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "DeleteResult" => %{
              "Deleted" => [%{"key" => "object1"}, %{"key" => "object2"}]
            }
          },
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
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
  @spec delete_multiple_objects(Config.t(), String.t(), [String.t()],
          encoding_type: :url,
          quiet: boolean()
        ) ::
          {:error, error()} | {:ok, Response.t()}
  def delete_multiple_objects(config, bucket, objects, options \\ []) do
    headers =
      case options[:encoding_type] do
        :url -> %{"encoding-type" => "url"}
        _ -> %{}
      end

    quiet = Keyword.get(options, :quiet, false)
    body = EEx.eval_string(@body_tmpl, quiet: quiet, objects: objects)

    Service.post(config, bucket, nil, body, headers: headers, sub_resources: %{"delete" => nil})
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
        signature: "W835KpLsL6k1/oo28RcsEflB6hw="
      }

  """
  @spec sign_post_policy(Config.t(), map()) :: %{
          policy: String.t(),
          signature: String.t()
        }
  def sign_post_policy(config, %{} = policy) do
    secret = config.access_key_secret
    encoded_policy = policy |> Jason.encode!() |> Base.encode64()

    %{
      policy: encoded_policy,
      signature: Aliyun.Util.Sign.sign(encoded_policy, secret)
    }
  end

  defp post_object(config, bucket, object, body, headers, sub_resources) do
    Service.post(config, bucket, object, body, headers: headers, sub_resources: sub_resources)
  end
end
