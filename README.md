# AliyunOss

[![Run Tests](https://github.com/ug0/aliyun_oss/actions/workflows/test.yml/badge.svg)](https://github.com/ug0/aliyun_oss/actions/workflows/test.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/aliyun_oss.svg)](https://hex.pm/packages/aliyun_oss)

阿里云对象存储（OSS）API（使用阿里云 V4 签名）

## Installation

Add `aliyun_oss` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aliyun_oss, "~> 3.0"}
  ]
end
```

## Usage

```elixir
defmodule MyApp.Oss do
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Bucket

  def list_buckets(query_params \\ %{}) do
    Bucket.list_buckets(config(), query_params)
  end

  # encapsulate more API that you required ...

  def config() do
    :my_app
    |> Application.fetch_env!(MyApp.Oss)
    |> Config.new!()
  end
end

# In the config/runtime.exs
config :my_app, MyApp.Oss,
  region: "cn-hangzhou",
  endpoint: "oss-cn-hangzhou.aliyuncs.com",
  access_key_id: "YOUR_ACCESS_KEY_ID",
  access_key_secret: "YOUR_ACCESS_KEY_SECRET",
  security_token: "YOUR_STS_SECURITY_TOKEN" # for using STS token
```

## Documentation

[https://hexdocs.pm/aliyun_oss](https://hexdocs.pm/aliyun_oss)

### API List

更多请参考[阿里云官方文档](https://help.aliyun.com/document_detail/31948.html?spm=a2c4g.11186623.6.1037.520869cbKcHFcL)

## License

MIT
