defmodule Aliyun.Oss.Object.MultipartUpload do
  @moduledoc """
  Multipart Upload

  使用 Multipart Upload 模式上传数据

      iex> part_bytes = 102400 # The minimum allowed size is 100KB.
      iex> parts = File.stream!("/path/to/file", [], part_bytes)
      iex> Aliyun.Oss.Object.MultipartUpload.upload("some-bucket", "some-object", parts)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CompleteMultipartUploadResult" => %{
            "Bucket" => "some-bucket",
            "ETag" => "\"21000000000000000000000000000000-1\"",
            "Key" => "some-object",
            "Location" => "https://some-bucket.oss-cn-shenzhen.aliyuncs.com/some-object"
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

  alias Aliyun.Oss.Bucket
  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.{Response, Error}
  alias Aliyun.Oss.TaskSupervisor

  @type error() :: %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()


  @doc """
  使用 Multipart Upload 上传数据

  ## Examples

      iex> part_bytes = 102400 # The minimum allowed size is 100KB.
      iex> parts = File.stream!("/path/to/file", [], part_bytes)
      iex> Aliyun.Oss.Object.MultipartUpload.upload("some-bucket", "some-object", parts)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CompleteMultipartUploadResult" => %{
            "Bucket" => "some-bucket",
            "ETag" => "\"21000000000000000000000000000000-1\"",
            "Key" => "some-object",
            "Location" => "https://some-bucket.oss-cn-shenzhen.aliyuncs.com/some-object"
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
  @spec upload(String.t(), String.t(), Enum.t()) :: {:error, error()} | {:ok, Response.t()}
  def upload(bucket, object, parts) do
    case init_upload(bucket, object) do
      {:ok, upload_id} ->
        try do
          with {:ok, uploaded_parts} <- async_upload_parts(bucket, object, upload_id, parts),
               sorted_parts <- Enum.sort_by(uploaded_parts, &elem(&1, 0)),
               {:ok, resp} <- complete_upload(bucket, object, upload_id, sorted_parts) do
            {:ok, resp}
          else
            {:error, error} ->
              Task.Supervisor.start_child(TaskSupervisor, fn -> abort_upload(bucket, object, upload_id) end)
              {:error, error}
          end
        catch
          _, error ->
            Task.Supervisor.start_child(TaskSupervisor, fn -> abort_upload(bucket, object, upload_id) end)
            raise(error)
        end

      {:error, error} ->
        {:error, error}
    end
  end

  defp async_upload_parts(bucket, object, upload_id, parts) do
    Task.Supervisor.async_stream(
      TaskSupervisor,
      Stream.with_index(parts, 1),
      fn {binary, num} ->
        try do
          {num, upload_part(bucket, object, upload_id, num, binary)}
        catch
          _, _ -> {:error, {num, :failed}}
        end
      end,
      ordered: false,
      on_timeout: :kill_task
    )
    |> Enum.reduce_while({:ok, []}, fn
      {:ok, {part_number, {:ok, %{headers: headers}}}}, {:ok, uploaded_parts} ->
        {:cont, {:ok, [{part_number, get_etag_header(headers)} | uploaded_parts]}}

      _, _ ->
        {:halt, {:error, :failed_uploading_parts}}
    end)
  end

  defp get_etag_header(headers) do
    {_, etag} = Enum.find(headers, fn {k, _} -> k == "ETag" end)
    etag
  end

  @doc """
  InitiateMultipartUpload 初始化一个 Multipart Upload 事件

  ## Options

    - `:encoding_type` - default is blank, accept value: `:url`

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.init_upload("some-bucket", "some-object")
      {:ok, "UPLOAD_ID"}
  """
  @spec init_upload(String.t(), String.t(), map(), [encoding_type: :url]) :: {:error, error()} | {:ok, String.t()}
  def init_upload(bucket, object, headers \\ %{}, opts \\ []) do
    query_params =
      case Keyword.get(opts, :encoding_type) do
        :url -> %{"encoding-type" => "url"}
        _ -> %{}
      end

    case Service.post(bucket, object, "", query_params: query_params, headers: headers, sub_resources: %{"uploads" => nil}) do
      {:ok, %{data: %{"InitiateMultipartUploadResult" => %{"UploadId" => upload_id}}}} ->
        {:ok, upload_id}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  UploadPart
  初始化一个 MultipartUpload 之后，可以根据指定的 Object 名和 Upload ID 来分块（Part）上传数据。

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.upload_part("some-bucket", "some-object", "UPLOAD_ID", 1, "CONTENT")
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
  @spec upload_part(String.t(), String.t(), String.t(), integer(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def upload_part(bucket, object, upload_id, part_number, body) do
    sub_resources = %{"uploadId" => upload_id, "partNumber" => part_number}
    Service.put(bucket, object, body, sub_resources: sub_resources)
  end

  @doc """
  UploadPartCopy
  通过从一个已存在的 Object 中拷贝数据来上传一个 Part。

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.upload_part_copy("some-bucket", "some-object", "UPLOAD_ID", 1, "/SourceBucketName/SourceObjectName")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CopyPartResult" => %{
              "ETag" => "\"09800000000000000000000000000000\"",
              "LastModified" => "2017-05-14T07:44:26.000Z"
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
  @spec upload_part_copy(String.t(), String.t(), String.t(), integer(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def upload_part_copy(bucket, object, upload_id, part_number, copy_source, copy_source_range \\ "", headers \\ %{}) do
    sub_resources = %{"uploadId" => upload_id, "partNumber" => part_number}
    headers = Map.merge(headers, %{"x-oss-copy-source" => copy_source, "x-oss-copy-source-range" => copy_source_range})


    Service.put(bucket, object, "", sub_resources: sub_resources, headers: headers)
  end

  @doc """
  CompleteMultiUpload
  在将所有数据 Part 都上传完成后，必须调用 CompleteMultipartUpload 接口来完成整个文件的 MultipartUpload。

  ## Examples

      iex> uploaded_parts = [{1, "ETAG_FOR_PART1}, {2, "ETAG_FOR_PART2}]
      iex> Aliyun.Oss.Object.MultipartUpload.complete_upload("some-bucket", "some-object", "UPLOAD_ID", uploaded_parts)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CompleteMultipartUploadResult" => %{
              "Bucket" => "some-bucket",
              "ETag" => "\"21000000000000000000000000000000-1\"",
              "Key" => "some-object",
              "Location" => "https://some-bucket.oss-cn-shenzhen.aliyuncs.com/some-object"
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
  <CompleteMultipartUpload>
    <%= for {part_number, etag} <- parts do %>
    <Part>
      <PartNumber><%= part_number %></PartNumber>
      <ETag><%= etag %></ETag>
    </Part>
    <% end %>
  </CompleteMultipartUpload>
  """
  @spec complete_upload(String.t(), String.t(), String.t(), list({integer(), String.t()}), map()) :: {:error, error()} | {:ok, Response.t()}
  def complete_upload(bucket, object, upload_id, parts, headers \\ %{}) do
    body = EEx.eval_string(@body_tmpl, parts: parts)

    Service.post(bucket, object, body, headers: headers, sub_resources: %{"uploadId" => upload_id})
  end

  @doc """
  AbortMultipartUpload
  用于终止 MultipartUpload 事件。您需要提供 MultipartUpload 事件相应的 Upload ID。

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.abort_upload("some-bucket", "some-object", "UPLOAD_ID")
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
  @spec abort_upload(String.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def abort_upload(bucket, object, upload_id) do
    Service.delete(bucket, object, sub_resources: %{"uploadId" => upload_id})
  end

  @doc """
  ListMultipartUploads
  来列举所有执行中的 Multipart Upload 事件，即已经初始化但还未 Complete 或者 Abort 的 Multipart Upload 事件。

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.list_uploads("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "ListMultipartUploadsResult" => %{
              "Bucket" => "some-bucket",
              "Delimiter" => nil,
              "IsTruncated" => false,
              "KeyMarker" => nil,
              "MaxUploads" => "1000",
              "NextKeyMarker" => nil,
              "NextUploadIdMarker" => nil,
              "Prefix" => nil,
              "Upload" => [
                %{
                  "Initiated" => "2018-05-14T07:59:10.000Z",
                  "Key" => "some-object",
                  "StorageClass" => "Standard",
                  "UploadId" => "UPLOAD_ID"
                },
                %{
                  "Initiated" => "2018-05-14T07:59:10.000Z",
                  "Key" => "some-object",
                  "StorageClass" => "Standard",
                  "UploadId" => "UPLOAD_ID"
                }
              ],
              "UploadIdMarker" => nil
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
  @spec list_uploads(String.t(), map()) :: {:error, error()} | {:ok, Response.t()}
  def list_uploads(bucket, query_params \\ %{}) do
    Bucket.get_bucket(bucket, query_params, %{"uploads" => nil})
  end

  @doc """
  ListParts
  用于列举指定 Upload ID 所属的所有已经上传成功 Part。

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.list_parts("some-bucket", "some-object", "UPLOAD_ID")
      {:ok, %Aliyun.Oss.Client.Response{
          data:  %{
            "ListPartsResult" => %{
              "Bucket" => "some-bucket",
              "IsTruncated" => false,
              "Key" => "some-object",
              "MaxParts" => "1000",
              "NextPartNumberMarker" => "2",
              "Part" => [
                %{
                  "ETag" => "\"09000000000000000000000000000000\"",
                  "HashCrc64ecma" => "15248619871383844432",
                  "LastModified" => "2018-05-14T08:03:26.000Z",
                  "PartNumber" => "1",
                  "Size" => "1538"
                },
                %{
                  "ETag" => "\"2A000000000000000000000000000000\"",
                  "HashCrc64ecma" => "13658734736388254586",
                  "LastModified" => "2018-05-14T08:03:37.000Z",
                  "PartNumber" => "2",
                  "Size" => "18"
                }
              ],
              "PartNumberMarker" => "0",
              "StorageClass" => "Standard",
              "UploadId" => "UPLOAD_ID"
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
  @spec list_parts(String.t(), String.t(), String.t(), map()) :: {:error, error()} | {:ok, Response.t()}
  def list_parts(bucket, object, upload_id, query_params \\ %{}) do
    Service.get(bucket, object,
      query_params: query_params,
      sub_resources: %{"uploadId" => upload_id}
    )
  end
end
