defmodule Aliyun.Oss.Bucket.Tags do
  @moduledoc """
  Bucket Tags 相关操作
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 2]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() :: %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketTags用于获取存储空间（Bucket）的标签信息。

  ## Examples

      iex> Aliyun.Oss.Bucket.Tagging.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"Tagging" => %{"TagSet" => [%{"Key" => "key", "Value" => "value"}]}},
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Fri, 01 Mar 2019 06:26:07 GMT"},
            ...
          ]
        }
      }
  """
  @spec get(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(bucket) do
    get_bucket(bucket, %{}, %{"tagging" => nil})
  end

  @doc """
  PutBucketTags接口用来给某个存储空间（Bucket）添加或修改标签。

  ## Examples

      iex> Aliyun.Oss.Bucket.Tags.put("some-bucket", [{"key1", "value1"}, {:key2, "value2}])
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
  @spec put(String.t(), [{String.t(), String.t()}, ...]) :: {:error, error()} | {:ok, Response.t()}
  def put(bucket, tags) do
    xml_body = EEx.eval_string(@body_tmpl, [tags: tags])
    put_bucket(bucket, %{}, %{"tagging" => nil}, xml_body)
  end

  @doc """
  DeleteBucketTags接口用于删除存储空间（Bucket）标签。

  ## Examples

      iex> Aliyun.Oss.Bucket.Tags.delete("some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:19:45 GMT"},
          ...
        ]
      }}
      iex> Aliyun.Oss.Bucket.Tags.delete("unknown-bucket")
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "BucketName" => "unknown-bucket",
          "Code" => "NoSuchBucket",
          "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "The specified bucket does not exist.",
          "RequestId" => "5C38283EC84D1C4471F2F48A"
        },
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>",
        status_code: 404
      }}
  """
  @spec delete(String.t()) :: {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(bucket) do
    delete_bucket(bucket, %{"tagging" => nil})
  end
end
