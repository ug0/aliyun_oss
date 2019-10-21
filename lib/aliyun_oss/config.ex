defmodule Aliyun.Oss.Config do
  [:endpoint, :access_key_id, :access_key_secret]
  |> Enum.map(fn config ->
    def unquote(config)() do
      :aliyun_oss
      |> Application.get_env(unquote(config))
      |> Confex.Resolver.resolve!()
    end
  end)
end
