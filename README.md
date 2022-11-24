# AliyunOss

[![Build Status](https://travis-ci.org/ug0/aliyun_oss.svg?branch=master)](https://travis-ci.org/ug0/aliyun_oss)
[![Hex.pm](https://img.shields.io/hexpm/v/aliyun_oss.svg)](https://hex.pm/packages/aliyun_oss)

阿里云对象存储（OSS）API

## Installation

Add `aliyun_oss` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aliyun_oss, "~> 1.0"}
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
  endpoint: "...",
  access_key_id: "...",
  access_key_secret: "..."
```

## Documentation

[https://hexdocs.pm/aliyun_oss](https://hexdocs.pm/aliyun_oss)

### API List

更多请参考[阿里云官方文档](https://help.aliyun.com/document_detail/31948.html?spm=a2c4g.11186623.6.1037.520869cbKcHFcL)

## License

MIT
