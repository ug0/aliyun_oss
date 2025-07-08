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
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
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
    put_bucket(config, bucket, body_xml, query_params: %{"versioning" => nil})
  end

  @doc """
  GetBucketVersioning - gets the versioning state of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Versioning.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{"VersioningConfiguration" => %{"Status" => "Enabled"}},
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, query_params: %{"versioning" => nil})
  end

  @doc """
  GetBucketVersions (ListObjectVersions) - lists the versions of all objects and delete markers in a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Versioning.list_object_versions("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "ListVersionsResult" => %{
            "Delimiter" => nil,
            "DeleteMarker" => [
              %{
                "IsLatest" => "false",
                "Key" => "example",
                "LastModified" => "2019-04-09T07:27:28.000Z",
                "Owner" => %{
                  "DisplayName" => "12345125285864390",
                  "ID" => "1234512528586****"
                },
                "VersionId" => "CAEQMxiBgICAof2D0BYiIDJhMGE3N2M1YTI1NDQzOGY5NTkyNTI3MGYyMzJm****"
              },
            ],
            "IsTruncated" => true,
            "KeyMarker" => nil,
            "MaxKeys" => 100,
            "Name" => "some-bucket",
            "NextKeyMarker" => "docs/test2.txt",
            "NextVersionIdMarker" => "null",
            "Prefix" => nil,
            "Version" => [
              %{
                "ETag" => "\"250F8A0AE989679A22926A875F0A2****\"",
                "IsLatest" => "false",
                "Key" => "example",
                "LastModified" => "2019-04-09T07:27:28.000Z",
                "Owner" => %{
                  "DisplayName" => "12345125285864390",
                  "ID" => "1234512528586****"
                },
                "Size" => "93731",
                "StorageClass" => "Standard",
                "Type" => "Normal",
                "VersionId" => "CAEQMxiBgMDNoP2D0BYiIDE3MWUxNzgxZDQxNTRiODI5OGYwZGMwNGY3MzZjN****"
              },
              ...
            ],
            "VersionIdMarker" => nil,
          }
        },
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec list_object_versions(Config.t(), String.t(), map()) ::
          {:error, error()} | {:ok, Response.t()}
  def list_object_versions(config, bucket, query_params \\ %{}) do
    get_bucket(config, bucket, query_params: Map.put(query_params, "versions", nil))
  end
end
