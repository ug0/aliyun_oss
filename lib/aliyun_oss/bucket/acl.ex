defmodule Aliyun.Oss.Bucket.ACL do
  @moduledoc """
  Bucket operations - ACL.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 4, put_bucket: 5]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketAcl - gets the ACL of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.ACL.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "AccessControlPolicy" => %{
              "AccessControlList" => %{"Grant" => "private"},
              "Owner" => %{"DislayName" => "11111111", "ID" => "11111111"}
            }
          },
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"}
          ]
        }
      }

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, %{}, %{"acl" => nil})
  end

  @doc """
  PutBucketACL - modifies the ACL of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Acl.put("some-bucket", "public-read")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 04:43:42 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"Location", "/some-bucket"},
          {"x-oss-server-time", "333"}
        ]
      }}
      iex> Aliyun.Oss.Bucket.Acl.put("some-bucket", "invalid-permission")
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "ArgumentName" => "x-oss-acl",
          "ArgumentValue" => "invalid-read",
          "Code" => "InvalidArgument",
          "HostId" => "some-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "no such bucket access control exists",
          "RequestId" => "5C3000000000000000000000"
        },
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>",
        status_code: 400
      }}

  """
  @spec put(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put(config, bucket, acl) do
    put_bucket(config, bucket, %{"x-oss-acl" => acl}, %{"acl" => acl}, "")
  end
end
