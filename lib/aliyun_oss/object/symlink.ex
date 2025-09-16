defmodule Aliyun.Oss.Object.Symlink do
  @moduledoc """
  Object operations - Symlink.
  """

  import Aliyun.Oss.Object, only: [get_object: 4, put_object: 5]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.Response

  @doc """
  GetSymlink - gets a symbol link.

  ## Examples

      iex> Aliyun.Oss.Object.Symlink.get(config, "some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            "content-length" => ["0"],
            "content-type" => ["text/plain"],
            "date" => ["Fri, 11 Jul 2025 06:51:54 GMT"],
            "etag" => ["\"6751C61F42E*********************\""],
            "last-modified" => ["Fri, 08 Mar 2019 05:11:29 GMT"],
            "server" => ["AliyunOSS"],
            "x-oss-request-id" => ["6870B4******************"],
            "x-oss-server-time" => ["8"],
            "x-oss-symlink-target" => ["test.txt"],
            "x-oss-version-id" => ["null"]
          }
        }
      }

  """
  @spec get(Config.t(), String.t(), String.t()) :: {:error, Exception.t()} | {:ok, Response.t()}
  def get(config, bucket, object) do
    get_object(config, bucket, object, headers: %{}, query_params: %{"symlink" => nil})
  end

  @doc """
  PutSymlink - creates a symbolic link that points to target object.

  ## Options

  - `:storage_class` - the storage class of the symlink object, default is `"Standard"`. Acceptable values are:
      - `"Standard"`
      - `"IA"`
      - `"Archive"`
  - `:acl` - the access control list (ACL) of the symlink object, default is `"default"`. Acceptable values are:
      - `"default"`
      - `"private"`
      - `"public-read"`
      - `"public-read-write"`

  ## Examples

      iex> Aliyun.Oss.Object.Symlink.put("some-bucket", "symlink", "target-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            "content-length" => ["0"],
            ...
          }
        }
      }

  """
  @spec put(Config.t(), String.t(), String.t(), String.t(), keyword()) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def put(config, bucket, symlink, target_object, options \\ []) do
    storage_class = Keyword.get(options, :storage_class, "Standard")
    acl = Keyword.get(options, :acl, "default")

    put_object(
      config,
      bucket,
      symlink,
      "",
      headers: %{
        "x-oss-symlink-target" => target_object,
        "x-oss-storage-class" => storage_class,
        "x-oss-object-acl" => acl
      },
      query_params: %{"symlink" => nil}
    )
  end
end
