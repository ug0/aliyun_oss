defmodule Aliyun.Oss.XmlParser do
  def parse_xml(xml, root_node) do
    try do
      {:ok, do_parse_xml(xml, root_node)}
    catch
      {:error, message} -> {:error, message}
    end
  end

  @value_casting_rules [
      {"Prefix", :string},
      {"Marker", :string},
      {"IsTruncated", :boolean},
      {"MaxKeys", :integer}
  ]
  defp do_parse_xml(xml, root_node) do
    XmlToMap.naive_map(xml)
    |> Map.fetch!(root_node)
    |> format_map_values(@value_casting_rules)
  end

  defp format_map_values(map, rules) do
    map_keys = Map.keys(map)

    rules
    |> Stream.filter(fn {key, _} ->
      key in map_keys
    end)
    |> Enum.reduce(map, fn {key, type}, new_map ->
      Map.get_and_update!(new_map, key, fn old_value ->
        {old_value, cast_value(old_value, type)}
      end) |> elem(1)
    end)
  end

  defp cast_value("true", :boolean), do: true
  defp cast_value(_, :boolean), do: false
  defp cast_value(%{}, :map), do: %{}
  defp cast_value(%{}, _), do: nil
  defp cast_value(value, :float) do
    case Float.parse(value) do
      {n, _} -> n
      _ -> nil
    end
  end
  defp cast_value(value, :integer) do
    case Integer.parse(value) do
      {n, _} -> n
      _ -> nil
    end
  end
  defp cast_value(value, _), do: value
end
