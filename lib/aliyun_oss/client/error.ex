defmodule Aliyun.Oss.Client.Error do
  alias Aliyun.Oss.Client.Error

  defstruct [:status_code, :body, :parsed_details]


  def parse(error = %Error{body: body}) do
    %Error{error | parsed_details: parse_error_xml(body)}
  end

  def parse(body, status_code) do
    parse(%Error{status_code: status_code, body: body})
  end

  defp parse_error_xml(xml) do
    try do
      xml
      |> XmlToMap.naive_map()
      |> Map.fetch!("Error")
    catch
      {:error, _} -> nil
    end
  end
end
