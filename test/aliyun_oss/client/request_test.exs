defmodule Aliyun.Oss.Client.RequestTest do
  use ExUnit.Case
  doctest Aliyun.Oss.Client.Request

  alias Aliyun.Oss.Client.Request
  alias Aliyun.Oss.ConfigAlt, as: Config

  @endpoint "oss-example.oss-cn-hangzhou.aliyuncs.com"
  @access_key_id "44CF9590006BF252F707"
  @access_key_secret "OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV"

  describe "build_signed/2" do
    test "creates a signed request" do
      config =
        Config.new!(%{
          endpoint: @endpoint,
          access_key_id: @access_key_id,
          access_key_secret: @access_key_secret
        })

      headers = %{
        "Content-Type" => "text/html",
        "Content-MD5" => "ODBGOERFMDMzQTczRUY3NUE3NzA5QzdFNUYzMDQxNEM=",
        "Date" => "Thu, 17 Nov 2005 18:49:58 GMT",
        "X-OSS-Meta-Author" => "foo@bar.com",
        "X-OSS-Magic" => "abracadabra"
      }

      signed_request =
        Request.build_signed(config, %{
          verb: "PUT",
          host: "oss-example.oss-cn-hangzhou.aliyuncs.com",
          path: "/oss-example/nelson",
          resource: "/oss-example/nelson",
          headers: headers
        })

      assert %Request{
               headers: %{
                 "Authorization" => "OSS 44CF9590006BF252F707:26NBxoKdsyly4EDv6inkoDft/yA="
               }
             } = signed_request
    end
  end
end
