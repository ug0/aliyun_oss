defmodule Aliyun.Oss.Object do
  @moduledoc """
  Object 相关操作:
    - `Aliyun.Oss.Object`: Object 基本操作
    - `Aliyun.Oss.Object.MultipartUpload`: MultipartUpload 分片上传
    - `Aliyun.Oss.Object.ACL`: ACL 权限控制
    - `Aliyun.Oss.Object.Symlink`: Symlink 软链接
    - `Aliyun.Oss.Object.Tagging`: Tagging 标签
  """

  import Aliyun.Oss.Config, only: [endpoint: 0]

  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.{Request, Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  HeadObject只返回某个Object的meta信息，不返回文件内容。

  ## Examples

      iex> Aliyun.Oss.Object.head_object("some-bucket", "some-object")
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
      iex> Aliyun.Oss.Object.head_object("some-bucket", "unknown-object")
      {:error, %Aliyun.Oss.Client.Error{status_code: 404, body: "", parsed_details: nil}}
  """
  @spec head_object(String.t(), String.t(), map(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def head_object(bucket, object, headers \\ %{}, sub_resources \\ %{}) do
    Service.head(bucket, object, headers: headers, sub_resources: sub_resources)
  end

  @doc """
  GetObjectMeta 用于获取一个文件（Object）的元数据信息，包括该Object的ETag、Size、LastModified信息，并且不返回该Object的内容。

  ## Examples

      iex> Aliyun.Oss.Object.get_object_meta("some-bucket", "some-object")
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
  @spec get_object_meta(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_object_meta(bucket, object) do
    head_object(bucket, object, %{}, %{"objectMeta" => nil})
  end

  @doc """
  GetObject 用于获取某个 Object

  ## Examples

      iex> Aliyun.Oss.Object.get_object("some-bucket", "some-object")
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


  注：所有 SubResource 相关操作亦可由此接口实现, 即 Object.Acl.get("some-bucket", "some-object") 等同于 Object.get_object("some-bucket", "some-object", %{}, %{"acl" => nil})
  """
  @spec get_object(String.t(), String.t(), map(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_object(bucket, object, headers \\ %{}, sub_resources \\ %{}) do
    Service.get(bucket, object, headers: headers, sub_resources: sub_resources)
  end

  @doc """
  SelectObject用于对目标文件执行SQL语句，返回执行结果。

  ## Options

    - `:format` - 用于设置请求语法：`:json` or `:csv`, 默认为`:csv`

  ## Examples

      iex> select_request = %{
        "SelectRequest" => %{
          "Expression" => "c2VsZWN0ICogZnJvbSBvc3NvYmplY3QuY29udGFjdHNbKl0gcyB3aGVyZSBzLmFnZSA9IDI3",
          "InputSerialization" => %{"JSON" => %{"Type" => "DOCUMENT"}},
          "OutputSerialization" => %{"JSON" => %{"RecordDelimiter" => "LA=="}}
        }
      }
      iex> Aliyun.Oss.Object.select_object("some-bucket", "some-object", select_request, format: :json)
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
      iex> Aliyun.Oss.Object.select_object("some-bucket", "some-object", select_request, format: :json)
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
  @spec select_object(String.t(), String.t(), String.t() | map(), keyword) ::
          {:error, error()} | {:ok, Response.t()}
  def select_object(bucket, object, select_request, options \\ [])

  def select_object(bucket, object, %{} = select_request, options) do
    select_object(bucket, object, MapToXml.from_map(select_request), options)
  end

  def select_object(bucket, object, select_request, options) do
    x_oss_process =
      case Keyword.get(options, :format, :csv) do
        :csv -> "csv/select"
        :json -> "json/select"
      end

    post_object(bucket, object, select_request, %{}, %{"x-oss-process" => x_oss_process})
  end

  @doc """
  CreateSelectObjectMeta API用于获取目标文件总的行数，总的列数（对于CSV文件），以及Splits个数。如果该信息不存在，则会扫描整个文件，分析并记录下CSV文件的上述信息。重复调用该API则会保存上述信息而不必重新扫描整个文件。

  ## Options

    - `:format` - 用于设置请求语法：`:json` or `:csv`, 默认为`:csv`

  ## Examples

      iex> select_request = %{
        "JsonMetaRequest" => %{
          "InputSerialization" => %{"JSON" => %{"Type" => "LINES"}},
          "OverwriteIfExisting" => "false"
        }
      }
      iex> Aliyun.Oss.Object.select_object_meta("some-bucket", "some-object", select_request, format: :json)
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
      iex> Aliyun.Oss.Object.select_object_meta("some-bucket", "some-object", select_request, format: :json)
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
  @spec select_object_meta(String.t(), String.t(), String.t() | map(), keyword) ::
          {:error, error()} | {:ok, Response.t()}
  def select_object_meta(bucket, object, select_request, options \\ [])

  def select_object_meta(bucket, object, %{} = select_request, options) do
    select_object_meta(bucket, object, MapToXml.from_map(select_request), options)
  end

  def select_object_meta(bucket, object, select_request, options) do
    x_oss_process =
      case Keyword.get(options, :format, :csv) do
        :csv -> "csv/meta"
        :json -> "json/meta"
      end

    post_object(bucket, object, select_request, %{}, %{"x-oss-process" => x_oss_process})
  end

  @doc """
  生成包含签名的 Object URL

  ## Examples

      iex> expires = Timex.now() |> Timex.shift(days: 1) |> Timex.to_unix()
      iex> Aliyun.Oss.Object.signed_url("some-bucket", "some-object", expires, "GET", %{"Content-Type" => ""})
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc5*******9l&Expires=1141889120&Signature=vjbyPxybdZ*****************v4%3D"
      iex> Aliyun.Oss.Object.signed_url("some-bucket", "some-object", expires, "PUT", %{"Content-Type" => "text/plain"})
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc5*******9l&Expires=1141889120&Signature=vjbyPxybdZ*****************v4%3D"
  """
  @spec signed_url(String.t(), String.t(), integer(), String.t(), map(), map()) :: String.t()
  def signed_url(bucket, object, expires, method, headers, sub_resources \\ %{}) do
    %{
      verb: method,
      host: "#{bucket}.#{endpoint()}",
      path: "/#{object}",
      resource: "/#{bucket}/#{object}",
      sub_resources: sub_resources,
      headers: headers,
      expires: expires
    }
    |> Request.build()
    |> Request.to_signed_url()
  end

  @doc """
  生成包含签名的可用于直接访问的 Object URL

  ## Examples

      iex> expires = Timex.now() |> Timex.shift(days: 1) |> Timex.to_unix()
      iex> Aliyun.Oss.Object.object_url("some-bucket", "some-object", expires)
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc56s936**9l&Expires=1141889120&Signature=vjbyPxybdZaNmGa%2ByT272YEAiv4%3D"
  """
  @spec object_url(String.t(), String.t(), integer()) :: String.t()
  def object_url(bucket, object, expires) do
    signed_url(bucket, object, expires, "GET", %{"Content-Type" => ""})
  end

  @doc """
  PutObject接口用于上传文件（Object）。
   - 添加的文件大小不得超过 5 GB。
   - 如果已经存在同名的Object，并且有访问权限，则新添加的文件将覆盖原来的文件，并成功返回 200 OK。

  ## Examples

      iex> Aliyun.Oss.Object.put_object("some-bucket", "some-object", "CONTENT")
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
  @spec put_object(String.t(), String.t(), String.t(), map(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def put_object(bucket, object, body, headers \\ %{}, sub_resources \\ %{}) do
    Service.put(bucket, object, body, headers: headers, sub_resources: sub_resources)
  end

  @doc """
  CopyObject接口用于在存储空间（Bucket ） 内或同地域的Bucket之间拷贝文件（Object）。

  ## Examples

      iex> Aliyun.Oss.Object.copy_object({"source-bucket", "source-object"}, {"target-bucket", "target-object"})
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
  @spec copy_object({String.t(), String.t()}, {String.t(), String.t()}, map()) ::
          {:error, error()} | {:ok, Response.t()}
  def copy_object({source_bucket, source_object}, {target_bucket, target_object}, headers \\ %{}) do
    headers = Map.put(headers, "x-oss-copy-source", "/#{source_bucket}/#{source_object}")
    put_object(target_bucket, target_object, "", headers)
  end

  @doc """
  AppendObject接口用于以追加写的方式上传Object。

  ## Examples

      iex> Aliyun.Oss.Object.append_object("some-bucket", "some-object", "CONTENT", 0)
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
  @spec append_object(String.t(), String.t(), String.t(), integer(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def append_object(bucket, object, body, position, headers \\ %{}) do
    post_object(bucket, object, body, headers, %{"append" => nil, "position" => position})
  end

  @doc """
  RestoreObject接口用于解冻归档类型（Archive）的文件（Object）。

  ## Examples

      iex> Aliyun.Oss.Object.restore_object("some-bucket", "some-object")
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
  @spec restore_object(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def restore_object(bucket, object) do
    post_object(bucket, object, "", %{}, %{"restore" => nil})
  end

  @doc """
  DeleteObject用于删除某个文件（Object）。

  ## Examples

      iex> Aliyun.Oss.Object.delete_object("some-bucket", "some-object")
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
  @spec delete_object(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def delete_object(bucket, object, sub_resources \\ %{}) do
    Service.delete(bucket, object, sub_resources: sub_resources)
  end

  @doc """
  DeleteMultipleObjects接口用于删除同一个存储空间（Bucket）中的多个文件（Object）。

  ## Options

    - `:encoding_type` - Accept value: `:url`
    - `:quiet` - Set `true` to enable the quiet mode, default is `false`

  ## Examples

      iex> Aliyun.Oss.Object.delete_multiple_objects("some-bucket", ["object1", "object2"])
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
  @spec delete_multiple_objects(String.t(), [String.t()], encoding_type: :url, quiet: boolean()) ::
          {:error, error()} | {:ok, Response.t()}
  def delete_multiple_objects(bucket, objects, options \\ []) do
    headers =
      case options[:encoding_type] do
        :url -> %{"encoding-type" => "url"}
        _ -> %{}
      end

    quiet = Keyword.get(options, :quiet, false)
    body = EEx.eval_string(@body_tmpl, quiet: quiet, objects: objects)

    Service.post(bucket, nil, body, headers: headers, sub_resources: %{"delete" => nil})
  end

  @doc """
  签名 Post Policy 返回签名字符串及编码后的 policy

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
      iex> Aliyun.Oss.Object.sign_post_policy(policy)
      %{
        policy: "eyJjb25kaXRpb25zIjpbWyJjb250ZW50LWxlbmd0aC1yYW5nZSIsMCwxMDQ4NTc2MF0seyJidWNrZXQiOiJhaGFoYSJ9LHsiQSI6ImEifSx7ImtleSI6IkFCQyJ9XSwiZXhwaXJhdGlvbiI6IjIwMTMtMTItMDFUMTI6MDA6MDBaIn0=",
        signature: "W835KpLsL6k1/oo28RcsEflB6hw="
      }
  """
  @spec sign_post_policy(map(), String.t()) :: %{policy: String.t(), signature: String.t()}
  def sign_post_policy(%{} = policy, key \\ Aliyun.Oss.Config.access_key_secret()) do
    encoded_policy = policy |> Jason.encode!() |> Base.encode64()

    %{
      policy: encoded_policy,
      signature: Aliyun.Util.Sign.sign(encoded_policy, key)
    }
  end

  defp post_object(bucket, object, body, headers, sub_resources) do
    Service.post(bucket, object, body, headers: headers, sub_resources: sub_resources)
  end
end
