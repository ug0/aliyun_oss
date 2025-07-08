defmodule Aliyun.Oss.Bucket.WORM do
  @moduledoc """
  Bucket operations - Retention policy.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, delete_bucket: 3]
  import Aliyun.Oss.Service, only: [post: 5]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  InitiateBucketWorm - creates a retention policy.

  ## Examples

      iex> Aliyun.Oss.Bucket.WORM.initiate("some-bucket", 1)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Tue, 08 Jul 2025 01:37:08 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686C70000000000000007373"],
          "x-oss-server-time" => ["44"],
          "x-oss-worm-id" => ["0E2910000000000000000000000F5D09"]
        }
      }}

  """
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <InitiateWormConfiguration>
    <RetentionPeriodInDays><%= days %></RetentionPeriodInDays>
  </InitiateWormConfiguration>
  """
  @spec initiate(Config.t(), String.t(), integer()) :: {:error, error()} | {:ok, Response.t()}
  def initiate(config, bucket, days) when is_integer(days) do
    body_xml = EEx.eval_string(@body_tmpl, days: days)
    post(config, bucket, nil, body_xml, query_params: %{"worm" => nil})
  end

  @doc """
  AbortBucketWorm - deletes an unlocked retention policy.

  ## Examples

      iex> Aliyun.Oss.Bucket.WORM.abort("some-bucket", "report1")
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive],
          ...
        }
      }}

  """
  @spec abort(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def abort(config, bucket) do
    delete_bucket(config, bucket, query_params: %{"worm" => nil})
  end

  @doc """
  CompleteBucketWorm - locks a retention policy.

  ## Examples

      iex> Aliyun.Oss.Bucket.WORM.complete("some-bucket", "worm_id_1")
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive],
          ...
        }
      }}

  """
  @spec complete(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def complete(config, bucket, worm_id) do
    post(config, bucket, nil, "", query_params: %{"wormId" => worm_id})
  end

  @doc """
  ExtendBucketWorm - extends the retention period of objects in an bucket whose retention policy is locked.

  ## Examples

      iex> Aliyun.Oss.Bucket.WORM.extend("some-bucket", "worm_id_1")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive],
          ...
        }
      }}

  """
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <ExtendWormConfiguration>
    <RetentionPeriodInDays><%= days %></RetentionPeriodInDays>
  </ExtendWormConfiguration>
  """
  @spec extend(Config.t(), String.t(), String.t(), integer()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def extend(config, bucket, worm_id, days) when is_integer(days) do
    body_xml = EEx.eval_string(@body_tmpl, days: days)

    post(config, bucket, nil, body_xml, query_params: %{"wormId" => worm_id, "wormExtend" => nil})
  end

  @doc """
  GetBucketWorm - gets the retention policy configured for the specified bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.WORM.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "WormConfiguration" => %{
            "CreationDate" => "2021-01-19T08:34:39.000Z",
            "ExpirationDate" => "2021-01-20T08:34:39.000Z",
            "RetentionPeriodInDays" => "1",
            "State" => "InProgress",
            "WormId" => "20000000000000000000000000000000"
          }
        },
        headers: %{
          "connection" => ["kee-alive],
          ...
        }
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, query_params: %{"worm" => nil})
  end
end
