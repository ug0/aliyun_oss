defmodule Aliyun.Oss.Config do
  @enforce_keys [:region, :endpoint, :access_key_id, :access_key_secret]
  defstruct [:security_token | @enforce_keys]

  @type config() :: %{
          region: String.t(),
          endpoint: String.t(),
          access_key_id: String.t(),
          access_key_secret: String.t(),
          security_token: String.t() | nil
        }

  @type t :: %__MODULE__{
          region: String.t(),
          endpoint: String.t(),
          access_key_id: String.t(),
          access_key_secret: String.t(),
          security_token: String.t() | nil
        }

  @spec new!(config()) :: __MODULE__.t()
  def new!(config) when is_map(config) do
    config
    |> validate_required_keys!()
    |> as_struct!()
  end

  defp validate_required_keys!(
         %{
           region: region,
           endpoint: endpoint,
           access_key_id: access_key_id,
           access_key_secret: access_key_secret
         } = config
       )
       when is_binary(region) and is_binary(endpoint) and is_binary(access_key_id) and is_binary(access_key_secret) do
    config
  end

  defp validate_required_keys!(_config) do
    raise ArgumentError, "config :region, :endpoint, :access_key_id, :access_key_secret are required"
  end

  defp as_struct!(config) do
    struct!(__MODULE__, config)
  end
end
