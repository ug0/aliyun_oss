defmodule Aliyun.Oss.Service do
  alias Aliyun.Oss.Client

  @type error_details() :: {:http_error, String.t()} | {:xml_parse_error, String.t()} | {:oss_error, integer(), map()}

  @spec get(String.t(), String.t(), String.t(), map(), map()) :: {:error, error_details()} | {:ok, map()}
  def get(host, path, resource, query_params \\ %{}, sub_resources \\ %{}) do
    Client.request(%{
      verb: "GET",
      host: host,
      path: path,
      resource: resource,
      query_params: query_params,
      sub_resources: sub_resources
    })
  end
end
