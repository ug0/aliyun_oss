defmodule Aliyun.Oss.Bucket.ACL do
  @moduledoc """
  Bucket operations - ACL.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.Response

  @doc """
  GetBucketAcl - gets the ACL of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.ACL.get(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "AccessControlPolicy" => %{
              "AccessControlList" => %{"Grant" => "private"},
              "Owner" => %{"DislayName" => "11111111", "ID" => "11111111"}
            }
          },
          headers: %{
            "connection" => ["keep-alive],
            ...
          }
        }
      }

  """
  @spec get(Config.t(), String.t()) :: {:error, Exception.t()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, query_params: %{"acl" => nil})
  end

  @doc """
  PutBucketACL - modifies the ACL of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.ACL.put(config, "some-bucket", "public-read")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Tue, 08 Jul 2025 02:11:14 GMT"],
          "location" => ["/some-bucket"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686C00000000000000000D6B"],
          "x-oss-server-time" => ["479"]
        }
      }}
      iex> Aliyun.Oss.Bucket.ACL.put(config, "some-bucket", "invalid-permission")
      {:error,
      %Aliyun.Oss.Client.Error{
        status: 400,
        code: "InvalidArgument",
        message: "no such bucket access control exists",
        details: %{
          "ArgumentName" => "x-oss-acl",
          "ArgumentValue" => "invalid-permission",
          "Code" => "InvalidArgument",
          "EC" => "0015-00000204",
          "HostId" => "some-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "no such bucket access control exists",
          "RecommendDoc" => "https://api.aliyun.com/troubleshoot?q=0015-00000204,
          "RequestId" => "5C3000000000000000000000"
        }
      }}

  """
  @spec put(Config.t(), String.t(), String.t()) ::
          {:error, Exception.t()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put(config, bucket, acl) do
    put_bucket(config, bucket, "", headers: %{"x-oss-acl" => acl, "acl" => acl})
  end
end
