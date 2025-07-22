defmodule Aliyun.Oss.SignTest do
  use ExUnit.Case
  doctest Aliyun.Oss.Sign

  alias Aliyun.Oss.Sign
  alias Aliyun.Oss.Config

  @access_key_id "LTAI****************"
  @access_key_secret "yourAccessKeySecret"
  @region "cn-hangzhou"
  @endpoint "oss-#{@region}.aliyuncs.com"
  @date "20250411"

  @signing_key "8a01ff4efcc65ca2cbc75375045c61ab5f3fa8b9a2d84f0add27ef16a25feb3c"

  @config Config.new!(%{
            region: @region,
            endpoint: @endpoint,
            access_key_id: @access_key_id,
            access_key_secret: @access_key_secret
          })

  describe "get_signing_key/2" do
    test "returns the signing key" do
      assert Sign.get_signing_key(@config, @date) |> Base.encode16(case: :lower) == @signing_key
    end
  end
end
