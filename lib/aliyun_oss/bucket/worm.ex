defmodule Aliyun.Oss.Bucket.WORM do
  @moduledoc """
  Bucket WORM 相关操作
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, delete_bucket: 2]
  import Aliyun.Oss.Service, only: [post: 4]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() :: %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  InitiateBucketWorm用于新建一条合规保留策略。

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
  @spec initiate(String.t(), integer()) :: {:error, error()} | {:ok, Response.t()}
  def initiate(bucket, days) when is_integer(days) do
    body_xml = EEx.eval_string(@body_tmpl, days: days)
    post(bucket, nil, body_xml, sub_resources: %{"worm" => nil})
  end

  @doc """
  AbortBucketWorm用于删除未锁定的合规保留策略。

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
  @spec abort(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def abort(bucket) do
    delete_bucket(bucket, %{"worm" => nil})
  end

  @doc """
  CompleteBucketWorm用于锁定合规保留策略。

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
  @spec complete(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def complete(bucket, worm_id) do
    post(bucket, nil, "", sub_resources: %{"wormId" => worm_id})
  end

  @doc """
  ExtendBucketWorm用于延长已锁定的合规保留策略对应Bucket中Object的保留天数。

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
  @spec extend(String.t(), String.t(), integer()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def extend(bucket, worm_id, days) when is_integer(days) do
    body_xml = EEx.eval_string(@body_tmpl, days: days)
    post(bucket, nil, body_xml, sub_resources: %{"wormId" => worm_id, "wormExtend" => nil})
  end

  @doc """
  GetBucketWorm用于获取指定存储空间（Bucket）的合规保留策略信息。

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
  @spec get(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(bucket) do
    get_bucket(bucket, %{}, %{"worm" => nil})
  end
end
