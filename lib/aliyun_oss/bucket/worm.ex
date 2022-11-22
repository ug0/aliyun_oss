defmodule Aliyun.Oss.Bucket.WORM do
  @moduledoc """
  Bucket operations - Retention policy.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 4, delete_bucket: 3]
  import Aliyun.Oss.Service, only: [post: 5]
  alias Aliyun.Oss.ConfigAlt, as: Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  InitiateBucketWorm - creates a retention policy.

  ## Examples

      iex> Aliyun.Oss.Bucket.WORM.initiate("some-bucket", 1)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"x-oss-worm-id", "F0000000000000000000000000000000"},
          ...
        ]
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
    post(config, bucket, nil, body_xml, sub_resources: %{"worm" => nil})
  end

  @doc """
  AbortBucketWorm - deletes an unlocked retention policy.

  ## Examples

      iex> Aliyun.Oss.Bucket.WORM.abort("some-bucket", "report1")
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          ...
        ]
      }}

  """
  @spec abort(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def abort(config, bucket) do
    delete_bucket(config, bucket, %{"worm" => nil})
  end

  @doc """
  CompleteBucketWorm - locks a retention policy.

  ## Examples

      iex> Aliyun.Oss.Bucket.WORM.complete("some-bucket", "worm_id_1")
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          ...
        ]
      }}

  """
  @spec complete(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def complete(config, bucket, worm_id) do
    post(config, bucket, nil, "", sub_resources: %{"wormId" => worm_id})
  end

  @doc """
  ExtendBucketWorm - extends the retention period of objects in an bucket whose retention policy is locked.

  ## Examples

      iex> Aliyun.Oss.Bucket.WORM.extend("some-bucket", "worm_id_1")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          ...
        ]
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

    post(config, bucket, nil, body_xml, sub_resources: %{"wormId" => worm_id, "wormExtend" => nil})
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
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, %{}, %{"worm" => nil})
  end
end
