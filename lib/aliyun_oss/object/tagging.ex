defmodule Aliyun.Oss.Object.Tagging do
  @moduledoc """
  Object operations - Tagging.
  """

  import Aliyun.Oss.Object, only: [get_object: 4, put_object: 5, delete_object: 4]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetObjectTagging - gets the tags of an object.

  ## Examples

      iex> Aliyun.Oss.Object.Tagging.get(config, "some-bucket", "some-object")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"Tagging" => %{"TagSet" => [%{"Key" => "key", "Value" => "value"}]}},
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
    get_object(config, bucket, object, headers: %{}, query_params: %{"tagging" => nil})
  end

  @doc """
  PutObjectTagging - adds tags to an object or updates the tags added to the object.

  ## Examples

      iex> Aliyun.Oss.Object.Tagging.put(config, "some-bucket", "some-object", [{"key1", "value1"}, {:key2, "value2}])
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
  @spec put(Config.t(), String.t(), String.t(), [{any(), any()}, ...]) ::
          {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, object, tags) do
    xml_body = EEx.eval_string(@body_tmpl, tags: tags)
    put_object(config, bucket, object, xml_body, query_params: %{"tagging" => nil})
  end

  @doc """
  DeleteObjectTagging - deletes the tags of an object.

  ## Examples

      iex> Aliyun.Oss.Object.Tagging.delete("some-bucket", "some-object")
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
  @spec delete(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def delete(config, bucket, object) do
    delete_object(config, bucket, object, %{"tagging" => nil})
  end
end
