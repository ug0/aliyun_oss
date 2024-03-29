defmodule Aliyun.Oss.Client.LiveChannelTest do
  use ExUnit.Case

  alias Aliyun.Oss.LiveChannel
  alias Aliyun.Oss.Config

  @endpoint "oss-example.oss-cn-hangzhou.aliyuncs.com"
  @access_key_id "44CF9590006BF252F707"
  @access_key_secret "OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV"
  describe "signed_publish_url/4" do
    test "build signed rtmp publish url" do
      config =
        Config.new!(%{
          endpoint: @endpoint,
          access_key_id: @access_key_id,
          access_key_secret: @access_key_secret
        })

      assert LiveChannel.signed_publish_url(
               config,
               "test_bucket",
               "test_channel",
               1_547_105_286,
               %{"playlistName" => "list.m3u8"}
             ) ==
               "rtmp://test_bucket.oss-example.oss-cn-hangzhou.aliyuncs.com/live/test_channel?Expires=1547105286&OSSAccessKeyId=44CF9590006BF252F707&Signature=JvQe2X2bOTmJ3H%2FXQcWlW7Mh4gc%3D&playlistName=list.m3u8"
    end
  end
end
