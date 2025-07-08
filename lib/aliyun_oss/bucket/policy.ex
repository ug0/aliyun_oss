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
      iex> Aliyun.Oss.Bucket.Policy.put(config, "some-bucket", policy)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec put(Config.t(), String.t(), map()) :: {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, %{} = policy) do
    put_bucket(config, bucket, JSON.encode!(policy), query_params: %{"policy" => nil})
  end

  @doc """
  GetBucketPolicy - gets the policies configured for a specified bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Policy.get(config, "some-bucket")
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
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, query_params: %{"policy" => nil})
  end

  @doc """
  GetBucketPolicyStatus

  ## Examples

      iex> Aliyun.Oss.Bucket.Policy.get_status(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "PolicyStatus" => %{"IsPublic" => "false"}
        },
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec get_status(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_status(config, bucket) do
    get_bucket(config, bucket, query_params: %{"policyStatus" => nil})
  end

  @doc """
  DeleteBucketPolicy - deletes the policies configured for a specified bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Policy.delete("some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Tue, 08 Jul 2025 07:43:42 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686CCC2E68CDB***********"],
          "x-oss-server-time" => ["69"]
        }
      }}

  """
  @spec delete(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket) do
    delete_bucket(config, bucket, query_params: %{"policy" => nil})
  end
end
