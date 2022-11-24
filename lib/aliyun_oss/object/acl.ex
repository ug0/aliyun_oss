defmodule Aliyun.Oss.Object.ACL do
  @moduledoc """
  Object operations - ACL.
  """

  import Aliyun.Oss.Object, only: [get_object: 5, put_object: 6]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetObjectACL - gets the access control list (ACL) of an object.

  ## Examples

      iex> Aliyun.Oss.Object.ACL.get(config, "some-bucket", "some-object")
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
  @spec get(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket, object) do
    get_object(config, bucket, object, %{}, %{"acl" => nil})
  end

  @doc """
  PutObjectACL - modifies the access control list (ACL) of an object.

  ## Examples

      iex> Aliyun.Oss.Object.ACL.put(config, "some-bucket", "some-object", "private")
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
  @spec put(Config.t(), String.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, object, acl) do
    put_object(config, bucket, object, "", %{"x-oss-object-acl" => acl}, %{"acl" => nil})
  end
end
