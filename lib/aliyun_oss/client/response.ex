defmodule Aliyun.Oss.Client.Response do
  defstruct [:data, :headers]

  @type t :: %__MODULE__{
          data: map(),
          headers: map()
        }

  @value_casting_rules %{
    "Prefix" => :string,
    "Marker" => :string,
    "IsTruncated" => :boolean,
    "MaxKeys" => :integer,
    "KeyCount" => :integer,
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
    %__MODULE__{
      data: parse_body(body, parse_content_type(headers)),
      headers: headers
    }
  end

  defp parse_content_type(headers) do
    headers
    |> Stream.map(fn
      {key, [value]} -> {key, value}
      {key, value} -> {key, value}
    end)
    |> Enum.find(fn {key, _value} -> String.downcase(key) == "content-type" end)
    |> case do
      {_, "application/json"} -> :json
      {_, "application/xml"} -> :xml
      _ -> nil
    end
  end

  defp parse_body(body, :xml) when is_binary(body), do: body |> XmlToMap.naive_map() |> cast_data()
  defp parse_body(body, :json) when is_binary(body), do: body |> Jason.decode!() |> cast_data()
  defp parse_body(body, _), do: body

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
