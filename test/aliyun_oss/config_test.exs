defmodule Aliyun.Oss.ConfigTest do
  use ExUnit.Case
  alias Aliyun.Oss.Config

  describe "new!/1" do
    test "creates a %Config{} struct" do
      assert %Config{region: _, endpoint: _, access_key_id: _, access_key_secret: _, security_token: nil} =
               Config.new!(%{
                 region: "cn-hangzhou",
                 endpoint: "...",
                 access_key_id: "...",
                 access_key_secret: "..."
               })
    end

    test "raises ArgumentError when required keys are missing" do
      assert_raise ArgumentError,
                   "config :region, :endpoint, :access_key_id, :access_key_secret are required",
                   fn ->
                     Config.new!(%{})
                   end
    end
  end
end
