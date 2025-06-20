defmodule Aliyun.Oss.Client.ObjectTest do
  use ExUnit.Case

  alias Aliyun.Oss.Object
  alias Aliyun.Oss.Config

  @region "cn-hangzhou"
  @endpoint "oss-example.oss-cn-hangzhou.aliyuncs.com"
  @access_key_id "44CF9590006BF252F707"
  @access_key_secret "OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV"

  @config Config.new!(%{
            region: @region,
            endpoint: @endpoint,
            access_key_id: @access_key_id,
            access_key_secret: @access_key_secret
          })

  describe "signed_url/5" do
    test "build signed object url for GET" do
      assert Object.signed_url(@config, "test_bucket", "test_object_key", 1_547_105_286, "GET", %{
               "Content-Type" => ""
             }) ==
               "https://test_bucket.oss-example.oss-cn-hangzhou.aliyuncs.com/test_object_key?Expires=1547105286&OSSAccessKeyId=44CF9590006BF252F707&Signature=8bRz6KZY9DF93%2F4whvcyyv3UY4k%3D"

      assert Object.signed_url(
               @config,
               "test_bucket",
               "test_object_key",
               1_547_105_286,
               "GET",
               %{"Content-Type" => ""},
               %{"acl" => nil}
             ) ==
               "https://test_bucket.oss-example.oss-cn-hangzhou.aliyuncs.com/test_object_key?Expires=1547105286&OSSAccessKeyId=44CF9590006BF252F707&Signature=%2FNIaPMkHsNUdIUfwp7e%2BFz%2FvytI%3D&acl="
    end

    test "build signed object url for PUT" do
      assert Object.signed_url(@config, "test_bucket", "test_object_key", 1_547_105_286, "PUT", %{
               "Content-Type" => "text/plain"
             }) ==
               "https://test_bucket.oss-example.oss-cn-hangzhou.aliyuncs.com/test_object_key?Expires=1547105286&OSSAccessKeyId=44CF9590006BF252F707&Signature=qEYcrQ8CvOxaqVZZ8Kcw%2B3pf2EA%3D"

      assert Object.signed_url(
               @config,
               "test_bucket",
               "test_object_key",
               1_547_105_286,
               "PUT",
               %{"Content-Type" => "text/plain", "x-oss-object-acl" => "private"},
               %{"acl" => nil}
             ) ==
               "https://test_bucket.oss-example.oss-cn-hangzhou.aliyuncs.com/test_object_key?Expires=1547105286&OSSAccessKeyId=44CF9590006BF252F707&Signature=ca%2BwDexHaI3vO3LV6qZryoMUKYM%3D&acl="
    end
  end

  describe "object_url/2" do
    test "build signed object url for downloading" do
      assert Object.object_url(@config, "test_bucket", "test_object_key", 1_547_105_286) ==
               "https://test_bucket.oss-example.oss-cn-hangzhou.aliyuncs.com/test_object_key?Expires=1547105286&OSSAccessKeyId=44CF9590006BF252F707&Signature=8bRz6KZY9DF93%2F4whvcyyv3UY4k%3D"
    end
  end

  describe "sign_post_policy/2" do
    test "sign post policy" do
      policy = %{
        "conditions" => [
          ["content-length-range", 0, 10_485_760],
          %{"bucket" => "ahaha"},
          %{"A" => "a"},
          %{"key" => "ABC"}
        ],
        "expiration" => "2013-12-01T12:00:00Z"
      }

      assert Object.sign_post_policy(@config, policy) == %{
               policy:
                 "eyJjb25kaXRpb25zIjpbWyJjb250ZW50LWxlbmd0aC1yYW5nZSIsMCwxMDQ4NTc2MF0seyJidWNrZXQiOiJhaGFoYSJ9LHsiQSI6ImEifSx7ImtleSI6IkFCQyJ9XSwiZXhwaXJhdGlvbiI6IjIwMTMtMTItMDFUMTI6MDA6MDBaIn0=",
               signature: "W835KpLsL6k1/oo28RcsEflB6hw="
             }
    end
  end
end
