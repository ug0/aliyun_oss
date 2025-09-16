defmodule Aliyun.Oss.Object.Tagging do
  @moduledoc """
  Object operations - Tagging.
  """

  import Aliyun.Oss.Object, only: [get_object: 4, put_object: 5, delete_object: 4]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.Response

  @doc """
  GetObjectTagging - gets the tags of an object.

  ## Examples

      iex> Aliyun.Oss.Object.Tagging.get(config, "some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"Tagging" => %{"TagSet" => [%{"Key" => "key", "Value" => "value"}]}},
          headers: %{
            "connection" => ["keep-alive"],
            "content-type" => ["application/xml"],
            "date" => ["Fri, 11 Jul 2025 07:12:14 GMT"],
            "server" => ["AliyunOSS"],
            "x-oss-request-id" => ["6870B94E9***************"],
            "x-oss-server-time" => ["66"],
            "x-oss-version-id" => ["null"]
          }
        }
      }

  """
  @spec get(Config.t(), String.t(), String.t()) :: {:error, Exception.t()} | {:ok, Response.t()}
  def get(config, bucket, object) do
    get_object(config, bucket, object, headers: %{}, query_params: %{"tagging" => nil})
  end

  @doc """
  PutObjectTagging - adds tags to an object or updates the tags added to the object.

  ## Examples

      iex> Aliyun.Oss.Object.Tagging.put(config, "some-bucket", "some-object", [{"key1", "value1"}, {:key2, "value2}])
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

  """
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <Tagging>
    <TagSet>
      <%= for {key, value} <- tags do %>
        <Tag>
          <Key><%= key %></Key>
          <Value><%= value %></Value>
        </Tag>
      <% end %>
    </TagSet>
  </Tagging>
  """
  @spec put(Config.t(), String.t(), String.t(), keyword() | [{String.t(), String.t()}, ...]) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def put(config, bucket, object, tags) when is_list(tags) do
    xml_body = EEx.eval_string(@body_tmpl, tags: tags)
    put_object(config, bucket, object, xml_body, query_params: %{"tagging" => nil})
  end

  @doc """
  DeleteObjectTagging - deletes the tags of an object.

  ## Examples

      iex> Aliyun.Oss.Object.Tagging.delete("some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

  """
  @spec delete(Config.t(), String.t(), String.t()) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def delete(config, bucket, object) do
    delete_object(config, bucket, object, query_params: %{"tagging" => nil})
  end
end
