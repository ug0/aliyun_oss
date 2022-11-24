defmodule Aliyun.Oss.Config do
  @enforce_keys [:endpoint, :access_key_id, :access_key_secret]
  defstruct @enforce_keys

  @type config() :: %{
          endpoint: String.t(),
          access_key_id: String.t(),
          access_key_secret: String.t()
        }

  @type t :: %__MODULE__{
          endpoint: String.t(),
          access_key_id: String.t(),
          access_key_secret: String.t()
        }

  @spec new!(config()) :: __MODULE__.t()
  def new!(config) when is_map(config) do
    config
    |> validate_required_keys!()
    |> as_struct!()
  end

  defp validate_required_keys!(
         %{
           endpoint: endpoint,
           access_key_id: access_key_id,
           access_key_secret: access_key_secret
         } = config
       )
       when is_binary(endpoint) and is_binary(access_key_id) and is_binary(access_key_secret) do
    config
  end

  defp validate_required_keys!(_config) do
    raise ArgumentError, "config :endpoint, :access_key_id, :access_key_secret are required"
  end

  defp as_struct!(config) do
    struct!(__MODULE__, config)
  end
end
