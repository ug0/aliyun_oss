defmodule Aliyun.Oss.Bucket.Versioning do
  @moduledoc """
  Bucket Versioning 相关操作
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() :: %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  PutBucketVersioning用于设置指定存储空间（Bucket）的版本控制状态。

  ## Examples

      iex> Aliyun.Oss.Bucket.Versioning.put("some-bucket", "Enabled")
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
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <VersioningConfiguration>
    <Status><%= status %></Status>
  </VersioningConfiguration>
  """
  @spec put(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def put(bucket, status) do
    body_xml = EEx.eval_string(@body_tmpl, [status: status])
    put_bucket(bucket, %{}, %{"versioning" => nil}, body_xml)
  end


  @doc """
  GetBucketVersioning接口用于获取指定Bucket的版本控制状态。

  ## Examples

      iex> Aliyun.Oss.Bucket.Versioning.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{"VersioningConfiguration" => %{"Status" => "Enabled"}},
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
  """
  @spec get(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(bucket) do
    get_bucket(bucket, %{}, %{"versioning" => nil})
  end

  @doc """
  GetBucketVersions(ListObjectVersions)接口用于列出Bucket中包括删除标记（Delete Marker）在内的所有Object的版本信息。

  ## Examples

      iex> Aliyun.Oss.Bucket.Versioning.list_object_versions("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "ListVersionsResult" => %{
            "Delimiter" => nil,
            "IsTruncated" => true,
            "KeyMarker" => nil,
            "MaxKeys" => 100,
            "Name" => "zidcn-test",
            "NextKeyMarker" => "docs/test2.txt",
            "NextVersionIdMarker" => "null",
            "Prefix" => nil,
            "Version" => [
              # ...
            ],
            "VersionIdMarker" => nil,
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
  """
  @spec list_object_versions(String.t(), map()) :: {:error, error()} | {:ok, Response.t()}
  def list_object_versions(bucket, query_params \\ %{}) do
    get_bucket(bucket, query_params, %{"versions" => nil})
  end
end
