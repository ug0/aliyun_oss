defmodule Aliyun.Oss.Object.MultipartUpload do
  @moduledoc """
  Object operations - Multipart Upload.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3]
  import Aliyun.Oss.Object, only: [get_object: 4, put_object: 5, post_object: 5, delete_object: 4]

  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}
  alias Aliyun.Oss.TaskSupervisor

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  A shortcut for uploading streaming data.

  ## Examples

      iex> part_bytes = 102400 # The minimum allowed size is 100KB.
      iex> parts = File.stream!("/path/to/file", [], part_bytes)
      iex> Aliyun.Oss.Object.MultipartUpload.upload(config, "some-bucket", "some-object", parts)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CompleteMultipartUploadResult" => %{
            "Bucket" => "some-bucket",
            "ETag" => "\"21******************************-1\"",
            "Key" => "some-object",
            "Location" => "https://some-bucket.oss-cn-shenzhen.aliyuncs.com/some-object"
            }
          },
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

  """
  @spec upload(Config.t(), String.t(), String.t(), Enum.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def upload(config, bucket, object, parts) do
    case init_upload(config, bucket, object) do
      {:ok, upload_id} ->
        try do
          with {:ok, uploaded_parts} <-
                 async_upload_parts(config, bucket, object, upload_id, parts),
               sorted_parts <- Enum.sort_by(uploaded_parts, &elem(&1, 0)),
               {:ok, resp} <- complete_upload(config, bucket, object, upload_id, sorted_parts) do
            {:ok, resp}
          else
            {:error, error} ->
              Task.Supervisor.start_child(TaskSupervisor, fn ->
                abort_upload(config, bucket, object, upload_id)
              end)

              {:error, error}
          end
        catch
          _, error ->
            Task.Supervisor.start_child(TaskSupervisor, fn ->
              abort_upload(config, bucket, object, upload_id)
            end)

            raise(error)
        end

      {:error, error} ->
        {:error, error}
    end
  end

  defp async_upload_parts(config, bucket, object, upload_id, parts) do
    Task.Supervisor.async_stream(
      TaskSupervisor,
      Stream.with_index(parts, 1),
      fn {binary, num} ->
        try do
          {num, upload_part(config, bucket, object, upload_id, num, binary)}
        catch
          _, _ -> {:error, {num, :failed}}
        end
      end,
      ordered: false,
      on_timeout: :kill_task
    )
    |> Enum.reduce_while({:ok, []}, fn
      {:ok, {part_number, {:ok, %{headers: headers}}}}, {:ok, uploaded_parts} ->
        {:cont, {:ok, [{part_number, get_etag_from_header(headers)} | uploaded_parts]}}

      _, _ ->
        {:halt, {:error, :failed_uploading_parts}}
    end)
  end

  defp get_etag_from_header(%{"etag" => [etag]}) when is_binary(etag) do
    etag
  end

  @doc """
  InitiateMultipartUpload - notifies OSS to initiate a multipart upload task before you perform
  multipart upload to upload data.

  ## Options

  - `:headers` - Defaults to `%{}`
  - `:encoding_type` - Default is blank, accept value: `:url`

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.init_upload(config, "some-bucket", "some-object")
      {:ok, "UPLOAD_ID"}

  """
  @spec init_upload(Config.t(), String.t(), String.t(), keyword()) ::
          {:error, error()} | {:ok, String.t()}
  def init_upload(config, bucket, object, options \\ []) do
    query_params =
      case Keyword.get(options, :encoding_type) do
        :url -> %{"encoding-type" => "url"}
        _ -> %{}
      end
      |> Map.put("uploads", nil)

    headers = Keyword.get(options, :headers, %{})

    case post_object(config, bucket, object, "",
           query_params: query_params,
           headers: headers
         ) do
      {:ok, %{data: %{"InitiateMultipartUploadResult" => %{"UploadId" => upload_id}}}} ->
        {:ok, upload_id}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  UploadPart - uploads data by part based on the specified object name and upload ID after you
  initiate a multipart upload operation.

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.upload_part(config, "some-bucket", "some-object", "UPLOAD_ID", 1, "CONTENT")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

  """
  @spec upload_part(Config.t(), String.t(), String.t(), String.t(), integer(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def upload_part(config, bucket, object, upload_id, part_number, body) do
    query_params = %{"uploadId" => upload_id, "partNumber" => part_number}
    put_object(config, bucket, object, body, query_params: query_params)
  end

  @doc """
  UploadPartCopy - copies data from an existing object to upload a part by adding a `x-oss-copy-request`
  header to UploadPart.

  ## Options

  - `:headers` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.upload_part_copy(config, "some-bucket", "some-object", "UPLOAD_ID", 1, "/SourceBucketName/SourceObjectName")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CopyPartResult" => %{
              "ETag" => "\"098*****************************\"",
              "LastModified" => "2017-05-14T07:44:26.000Z"
            }
          },
          headers: %{
            "connection" => ["keep-alive"],
            "content-type" => ["application/xml"],
            "date" => ["Mon, 21 Jul 2025 07:02:21 GMT"],
            "etag" => ["\"A65C****************************\""],
            "server" => ["AliyunOSS"],
            "x-oss-copied-size" => ["20"],
            "x-oss-hash-crc64ecma" => ["162113**************"],
            "x-oss-ia-retrieve-flow-type" => ["0"],
            "x-oss-request-id" => ["687DE*******************"],
            "x-oss-server-time" => ["125"]
          }
        }
      }

  """
  @spec upload_part_copy(
          Config.t(),
          String.t(),
          String.t(),
          String.t(),
          integer(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:error, error()} | {:ok, Response.t()}
  def upload_part_copy(
        config,
        bucket,
        object,
        upload_id,
        part_number,
        copy_source,
        copy_source_range \\ "",
        options \\ []
      ) do
    query_params = %{"uploadId" => upload_id, "partNumber" => part_number}

    headers =
      options
      |> Keyword.get(:headers, %{})
      |> Map.merge(%{
        "x-oss-copy-source" => copy_source,
        "x-oss-copy-source-range" => copy_source_range
      })

    put_object(config, bucket, object, "", headers: headers, query_params: query_params)
  end

  @doc """
  CompleteMultiUpload - completes the multipart upload task of an object after all parts of the
  object are uploaded.

  ## Options

  - `:headers` - Defaults to `%{}`
  - `:encoding_type` - Default is blank, accept value: `:url`

  ## Examples

      iex> uploaded_parts = [{1, "ETAG_FOR_PART1}, {2, "ETAG_FOR_PART2}]
      iex> Aliyun.Oss.Object.MultipartUpload.complete_upload(config, "some-bucket", "some-object", "UPLOAD_ID", uploaded_parts)
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
  @spec complete_upload(
          Config.t(),
          String.t(),
          String.t(),
          String.t(),
          list({integer(), String.t()}),
          keyword()
        ) ::
          {:error, error()} | {:ok, Response.t()}
  def complete_upload(config, bucket, object, upload_id, parts, options \\ []) do
    body = EEx.eval_string(@body_tmpl, parts: parts)
    headers = Keyword.get(options, :headers, %{})
    query_params =
      case Keyword.get(options, :encoding_type) do
        :url -> %{"encoding-type" => "url"}
        _ -> %{}
      end
      |> Map.put("uploadId", upload_id)

    post_object(config, bucket, object, body, headers: headers, query_params: query_params)
  end

  @doc """
  AbortMultipartUpload - cancels a multipart upload task and deletes the parts uploaded in the task.

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.abort_upload(config, "some-bucket", "some-object", "UPLOAD_ID")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

  """
  @spec abort_upload(Config.t(), String.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def abort_upload(config, bucket, object, upload_id) do
    delete_object(config, bucket, object, query_params: %{"uploadId" => upload_id})
  end

  @doc """
  ListMultipartUploads - lists all multipart upload tasks in progress.

  The result includes the tasks are not completed or canceled.

  ## Options

  - `:query_params` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.list_uploads(config, "some-bucket")
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
                  "Key" => "some-object1",
                  "StorageClass" => "Standard",
                  "UploadId" => "UPLOAD_ID1"
                },
                %{
                  "Initiated" => "2018-05-14T07:59:50.000Z",
                  "Key" => "some-object2",
                  "StorageClass" => "Standard",
                  "UploadId" => "UPLOAD_ID2"
                }
              ],
              "UploadIdMarker" => nil
            }
          },
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

  """
  @spec list_uploads(Config.t(), String.t(), keyword()) :: {:error, error()} | {:ok, Response.t()}
  def list_uploads(config, bucket, options \\ []) do
    options = Keyword.update(options, :query_params, %{"uploads" => nil}, &Map.put(&1, "uploads", nil))
    get_bucket(config, bucket, options)
  end

  @doc """
  ListParts - Lists all parts that are uploaded by using a specified upload ID.

  ## Options

  - `:query_params` - Defaults to `%{}`

  ## Examples

      iex> Aliyun.Oss.Object.MultipartUpload.list_parts(config, "some-bucket", "some-object", "UPLOAD_ID")
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
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

  """
  @spec list_parts(Config.t(), String.t(), String.t(), String.t(), keyword()) ::
          {:error, error()} | {:ok, Response.t()}
  def list_parts(config, bucket, object, upload_id, options \\ []) do
    options = Keyword.update(options, :query_params, %{"uploadId" => upload_id}, &Map.put(&1, "uploadId", upload_id))
    get_object(config, bucket, object, options)
  end
end
