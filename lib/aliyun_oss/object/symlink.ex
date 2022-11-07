defmodule Aliyun.Oss.Object.Symlink do
  @moduledoc """
  Object Symlink 相关操作
  """

  import Aliyun.Oss.Object, only: [get_object: 4, put_object: 5]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetSymlink接口用于获取符号链接。此操作需要您对该符号链接有读权限。

  ## Examples

      iex> Aliyun.Oss.Object.Symlink.get("some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Fri, 01 Mar 2019 06:26:07 GMT"},
            {"Content-Type", "text/plain"},
            {"Content-Length", "0"},
            {"Connection", "keep-alive"},
            {"x-oss-request-id", "5C7000000000000000000000"},
            {"Last-Modified", "Fri, 01 Mar 2019 06:23:13 GMT"},
            {"ETag", "\"6751C000000000000000000000000000\""},
            {"x-oss-symlink-target", "test.txt"},
            {"x-oss-server-time", "1"}
          ]
        }
      }
  """
  @spec get(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(bucket, object) do
    get_object(bucket, object, %{}, %{"symlink" => nil})
  end

  @doc """
  PutSymlink接口用于为OSS的TargetObject创建软链接，您可以通过该软链接访问TargetObject。

  ## Examples

      iex> Aliyun.Oss.Object.Symlink.put("some-bucket", "symlink", "target-object")
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
  @spec put(String.t(), String.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def put(bucket, symlink, target_object, storage_class \\ "Standard") do
    put_object(
      bucket,
      symlink,
      "",
      %{"x-oss-symlink-target" => target_object, "x-oss-storage-class" => storage_class},
      %{"symlink" => nil}
    )
  end
end
