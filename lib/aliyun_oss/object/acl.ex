defmodule Aliyun.Oss.Object.ACL do
  @moduledoc """
  Object ACL 相关操作
  """

  import Aliyun.Oss.Object, only: [get_object: 4, put_object: 5]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() :: %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetObjectACL 用来获取某个Bucket下的某个Object的访问权限。

  ## Examples

      iex> Aliyun.Oss.Object.ACL.get("some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "AccessControlPolicy" => %{
              "AccessControlList" => %{"Grant" => "default"},
              "Owner" => %{
                "DisplayName" => "1111111111111111",
                "ID" => "1111111111111111"
              }
            }
          },
          headers: [
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"}
          ]
        }
      }
  """
  @spec get(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(bucket, object) do
    get_object(bucket, object, %{}, %{"acl" => nil})
  end

  @doc """
  PutObjectACL接口用于修改Object的访问权限。

  ## Examples

      iex> Aliyun.Oss.Object.ACL.put("some-bucket", "some-object", "private")
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
  @spec put(String.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def put(bucket, object, acl) do
    put_object(bucket, object, "", %{"x-oss-object-acl" => acl}, %{"acl" => nil})
  end
end
