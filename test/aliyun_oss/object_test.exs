defmodule Aliyun.Oss.Client.ObjectTest do
  use ExUnit.Case

  import Mock
  alias Aliyun.Oss.Object
  alias Aliyun.Oss.Config

  @endpoint "oss-example.oss-cn-hangzhou.aliyuncs.com"
  @access_key_id "44CF9590006BF252F707"
  @access_key_secret "OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV"
  describe "object_url/2" do
    test "build signed headers" do
      with_mock Config,
        endpoint: fn -> @endpoint end,
        access_key_id: fn -> @access_key_id end,
        access_key_secret: fn -> @access_key_secret end do
        assert Object.object_url("test_bucket", "test_object_key", 1547105286) ==
                 "https://test_bucket.oss-example.oss-cn-hangzhou.aliyuncs.com/test_object_key?Expires=1547105286&OSSAccessKeyId=44CF9590006BF252F707&Signature=8bRz6KZY9DF93%2F4whvcyyv3UY4k%3D"
      end
    end
  end
end
