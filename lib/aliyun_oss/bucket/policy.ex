defmodule Aliyun.Oss.Bucket.Policy do
  @moduledoc """
  Bucket operations - Authorization policy.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 3]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  PutBucketPolicy - configures policies for a specified bucket.

  ## Examples

      iex> policy = %{
        "Statement" => [
          %{
            "Action" => ["oss:PutObject", "oss:GetObject"],
            "Effect" => "Deny",
            "Principal" => ["1234567890"],
            "Resource" => ["acs:oss:*:1234567890:*/*"]
          }
        ],
        "Version" => "1"
      }
      iex> Aliyun.Oss.Bucket.Policy.put("some-bucket", policy)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

  """
  @spec put(Config.t(), String.t(), map()) :: {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, %{} = policy) do
    put_bucket(config, bucket, %{"policy" => nil}, Jason.encode!(policy))
  end

  @doc """
  GetBucketPolicy - gets the policies configured for a specified bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Policy.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "Statement" => [
            %{
              "Action" => ["oss:PutObject", "oss:GetObject"],
              "Effect" => "Deny",
              "Principal" => ["1234567890"],
              "Resource" => ["acs:oss:*:1234567890:*/*"]
            }
          ],
          "Version" => "1"
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, %{"policy" => nil})
  end

  @doc """
  DeleteBucketPolicy - deletes the policies configured for a specified bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Policy.delete("some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:19:45 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C3000000000000000000000"},
          {"x-oss-server-time", "90"}
        ]
      }}

  """
  @spec delete(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket) do
    delete_bucket(config, bucket, %{"policy" => nil})
  end
end
