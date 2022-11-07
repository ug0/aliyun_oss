defmodule Aliyun.Oss.Client.RequestTest do
  use ExUnit.Case
  doctest Aliyun.Oss.Client.Request

  import Mock
  alias Aliyun.Oss.Client.Request
  alias Aliyun.Oss.Config

  @endpoint "oss-example.oss-cn-hangzhou.aliyuncs.com"
  @access_key_id "44CF9590006BF252F707"
  @access_key_secret "OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV"
  describe "build_signed_headers/1" do
    test "build signed headers" do
      with_mock Config,
        endpoint: fn -> @endpoint end,
        access_key_id: fn -> @access_key_id end,
        access_key_secret: fn -> @access_key_secret end do
        headers = %{
          "Content-Type" => "text/html",
          "Content-MD5" => "ODBGOERFMDMzQTczRUY3NUE3NzA5QzdFNUYzMDQxNEM=",
          "Date" => "Thu, 17 Nov 2005 18:49:58 GMT",
          "X-OSS-Meta-Author" => "foo@bar.com",
          "X-OSS-Magic" => "abracadabra"
        }

        signed_request =
          Request.build_signed(%{
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
end
