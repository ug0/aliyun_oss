defmodule Aliyun.Oss.Client.Response do
  def parse_error_xml!(xml) do
    get_data_map!(xml)
  end

  @value_casting_rules [
    {"Prefix", :string},
    {"Marker", :string},
    {"IsTruncated", :boolean},
    {"MaxKeys", :integer},
    {"Delimiter", :string}
  ]
  def parse_xml(xml) do
    try do
      {:ok, get_data_map!(xml) |> cast_map_values(@value_casting_rules)}
    catch
      {:error, message} -> {:error, message}
    end
  end

  defp get_data_map!(xml), do: XmlToMap.naive_map(xml) |> Map.values() |> List.first()

  defp cast_map_values(map, rules) do
    map_keys = Map.keys(map)

    rules
    |> Stream.filter(fn {key, _} ->
      key in map_keys
    end)
    |> Enum.reduce(map, fn {key, type}, new_map ->
      Map.get_and_update!(new_map, key, fn old_value ->
        {old_value, cast_value(old_value, type)}
      end)
      |> elem(1)
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
