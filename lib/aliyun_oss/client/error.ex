defmodule Aliyun.Oss.Client.Error do
  defexception [:status, :code, :message, :details]

  @impl true
  def exception(%{status: status, body: body}) do
    build(status, body)
  end

  def build(status, xml_body) when is_binary(xml_body) do
    case parse_error_xml(xml_body) do
      %{"Code" => code, "Message" => message} = details ->
        %__MODULE__{status: status, code: code, message: message, details: details}

      body ->
        %__MODULE__{status: status, code: nil, message: body, details: nil}
    end
  end

  defp parse_error_xml(xml) do
    try do
      try do
        xml
        |> XmlToMap.naive_map()
        |> Map.fetch!("Error")
      catch
        {:error, _} -> xml
      end
    rescue
      KeyError -> xml
    end
  end
end
