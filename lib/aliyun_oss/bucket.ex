defmodule Aliyun.Oss.Bucket do
  @moduledoc """
  Bucket 相关操作
  """

  import Aliyun.Oss.Config, only: [endpoint: 0]

  alias Aliyun.Oss.{Client, XmlParser}

  defstruct [:name, :location, :creation_date, :intranet_endpoint, :extranet_endpoint, :storage_class]

  def list_buckets(query_params \\ %{}, sub_resources \\ %{}) do
    case Client.request(%{
      verb: "GET",
      host: endpoint(),
      path: "/",
      resource: "/",
      query_params: query_params,
      sub_resources: sub_resources
    }) do
      {:ok, xml} -> parse_xml(xml, "ListAllMyBucketsResult")
      error_res -> error_res
    end
  end

  def get_bucket(bucket, query_params \\ %{}, sub_resources \\ %{}) do
    host = bucket <> "." <> endpoint()
    case Client.request(%{
      verb: "GET",
      host: host,
      resource: "/#{bucket}/",
      path: "/",
      query_params: query_params,
      sub_resources: sub_resources
    }) do
      {:ok, xml} -> parse_xml(xml, "ListBucketResult")
      error_res -> error_res
    end
  end

  defp parse_xml(xml, root_node) do
    case XmlParser.parse_xml(xml, root_node) do
      {:ok, result} -> {:ok, result}
      {:error, message} -> {:error, {:xml_parse_error, message}}
    end
  end
end
