defmodule Aliyun.Oss.Sign do
  alias Aliyun.Oss.Config

  def get_signing_key(%Config{} = config, date) do
    "aliyun_v4#{config.access_key_secret}"
    |> hmac_sha256(date)
    |> hmac_sha256(config.region)
    |> hmac_sha256("oss")
    |> hmac_sha256("aliyun_v4_request")
  end

  def sign(data, key) do
    key
    |> hmac_sha256(data)
    |> Base.encode16(case: :lower)
  end

  defp hmac_sha256(key, data) do
    :crypto.mac(:hmac, :sha256, key, data)
  end
end
