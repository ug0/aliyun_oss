defmodule Aliyun.Oss.Object.Symlink do
  @moduledoc """
  Object operation - Symlink.
  """

  import Aliyun.Oss.Object, only: [get_object: 5, put_object: 6]
  alias Aliyun.Oss.ConfigAlt, as: Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetSymlink - gets a symbol link.

  ## Examples

      iex> Aliyun.Oss.Object.Symlink.get(config, "some-bucket", "some-object")
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
  @spec get(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket, object) do
    get_object(config, bucket, object, %{}, %{"symlink" => nil})
  end

  @doc """
  PutSymlink - creates a symbolic link that points to target object.

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
  @spec put(Config.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, symlink, target_object, storage_class \\ "Standard") do
    put_object(
      config,
      bucket,
      symlink,
      "",
      %{"x-oss-symlink-target" => target_object, "x-oss-storage-class" => storage_class},
      %{"symlink" => nil}
    )
  end
end
