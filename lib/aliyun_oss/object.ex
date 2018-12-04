defmodule Aliyun.Oss.Object do
  @moduledoc """
  Object 相关操作
  """

  import Aliyun.Oss.Config, only: [endpoint: 0]

  alias Aliyun.Oss.Client
  alias Aliyun.Oss.Client.Response

  @type error_details() :: {:http_error, String.t()} | {:xml_parse_error, String.t()} | {:oss_error, integer(), map()}

  @doc """
  GetObject 用于获取某个 Object

  ## Examples

      iex> Aliyun.Oss.Object.get_object("some-bucket", "some-object")
      {:ok,
        <<208, 207, 17, 224, 161, 177, 26, 225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 62, 0, 3, 0, 254, 255, 9, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18,
          0, 0, 0, ...>>}


  亦可用于获取某个 Object 指定 SubResource(GetObjectXXX)。

  ## Examples

      iex> Aliyun.Oss.Object.get_object("some-bucket", "some-object", %{}, %{"acl" => nil}, fn body -> {:ok, body})
      {:ok,
      %{
        "AccessControlPolicy" => %{
          "AccessControlList" => %{"Grant" => "default"},
          "Owner" => %{
            "DisplayName" => "1111111111111111",
            "ID" => "1111111111111111"
          }
        }
      }}
  """
  @spec get_object(String.t(), String.t(), map(), map(), fun()) :: {:error, error_details()} | {:ok, map()}
  def get_object(bucket, object, headers \\ %{}, sub_resources \\ %{}, result_parser \\ &parse_plain/1) do
    Client.request(%{
      verb: "GET",
      host: "#{bucket}.#{endpoint()}",
      path: "/#{object}",
      headers: headers,
      resource: "/#{bucket}/#{object}",
      query_params: %{},
      sub_resources: sub_resources
    }, result_parser)
  end

  @doc """
  GetObjectACL 用来获取某个Bucket下的某个Object的访问权限。

  ## Examples

      iex> Aliyun.Oss.Object.get_object_acl("some-bucket", "some-object")
      {:ok,
      %{
        "AccessControlPolicy" => %{
          "AccessControlList" => %{"Grant" => "default"},
          "Owner" => %{
            "DisplayName" => "1111111111111111",
            "ID" => "1111111111111111"
          }
        }
      }}
  """
  @spec get_object_acl(String.t(), String.t()) :: {:error, error_details()} | {:ok, map()}
  def get_object_acl(bucket, object) do
    get_object(bucket, object, %{}, %{"acl" => nil}, &parse_xml/1)
  end

  def parse_xml(xml) do
    Response.parse_xml(xml)
  end

  def parse_plain(body) do
    {:ok, body}
  end
end
