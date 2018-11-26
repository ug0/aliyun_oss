defmodule Aliyun.Oss.Client.Response do
  import SweetXml

  def parse_error(xml) do
    xml
    |> xmap(
      code: ~x"//Code/text()",
      message: ~x"//Message/text()",
      request_id: ~x"//RequestId/text()",
      host_id: ~x"//HostId/text()"
    )
    |> Map.put(:raw, xml)
  end
end
