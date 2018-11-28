defmodule Aliyun.Oss.Client.Error do
  def parse_xml!(xml) do
    XmlToMap.naive_map(xml)
    |> Map.fetch!("Error")
  end
end
