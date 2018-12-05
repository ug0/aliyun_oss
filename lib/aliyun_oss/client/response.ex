defmodule Aliyun.Oss.Client.Response do
  alias Aliyun.Oss.Client.Response

  defstruct [:data, :headers]

  @value_casting_rules %{
    "Prefix" => :string,
    "Marker" => :string,
    "IsTruncated" => :boolean,
    "MaxKeys" => :integer,
    "Delimiter" => :string,
    "RuleNumber" => :integer,
    "HttpErrorCodeReturnedEquals" => :integer,
    "PassQueryString" => :boolean,
    "MirrorPassQueryString" => :boolean,
    "MirrorFollowRedirect" => :boolean,
    "MirrorCheckMd5" => :boolean,
    "PassAll" => :boolean,
    "HttpRedirectCode" => :integer
  }

  def parse(body, headers \\ []) do
    %Response{
      data: parse_body(body),
      headers: headers,
    }
  end

  def parse_body(body) do
    try do
      body
      |> XmlToMap.naive_map()
      |> cast_data()
    catch
      {:error, _ } -> body
    end
  end

  defp cast_data(map) do
    map
    |> Enum.reduce(map, fn
      {key, inner_map = %{}}, new_map when map_size(inner_map) > 0 ->
        case matched_rules(@value_casting_rules, Map.keys(inner_map)) do
          empty = %{} when map_size(empty) == 0 -> %{new_map | key => cast_data(inner_map)}
          # NOTE: assume only need to deal with the first level where the target keys appear
          rules -> %{new_map | key => cast_map_values(inner_map, rules)}
        end

      {key, value}, new_map ->
        %{new_map | key => cast_value(value, Map.get(@value_casting_rules, key))}
    end)
  end

  defp matched_rules(rules, keys) do
    rules
    |> Stream.filter(fn {k, _} -> k in keys end)
    |> Enum.into(%{})
  end

  defp cast_map_values(map = %{}, rules) do
    map
    |> Enum.reduce(map, fn {key, value}, new_map ->
      %{new_map | key => cast_value(value, Map.get(rules, key))}
    end)
  end

  defp cast_value("true", :boolean), do: true
  defp cast_value(_, :boolean), do: false
  defp cast_value(m = %{}, :map), do: m
  defp cast_value(m = %{}, _) when map_size(m) == 0, do: nil

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
