defmodule Aliyun.Oss.Bucket.Versioning do
  @moduledoc """
  Bucket operations - Versioning.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  PutBucketVersioning - configures the versioning state for a bucket.

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
  @spec put(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, status) do
    body_xml = EEx.eval_string(@body_tmpl, status: status)
    put_bucket(config, bucket, %{"versioning" => nil}, body_xml)
  end

  @doc """
  GetBucketVersioning - gets the versioning state of a bucket.

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
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, %{"versioning" => nil})
  end

  @doc """
  GetBucketVersions (ListObjectVersions) - lists the versions of all objects and delete markers in a bucket.

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
  @spec list_object_versions(Config.t(), String.t(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def list_object_versions(config, bucket, query_params \\ %{}) do
    get_bucket(config, bucket, Map.put(query_params, "versions", nil))
  end
end
