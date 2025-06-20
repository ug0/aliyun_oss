defmodule Aliyun.Oss.Client.RequestTest do
  use ExUnit.Case
  doctest Aliyun.Oss.Client.Request

  import Mock

  alias Aliyun.Oss.Client.Request
  alias Aliyun.Oss.Config

  @access_key_id "LTAI****************"
  @access_key_secret "yourAccessKeySecret"
  @bucket "examplebucket"
  @object "exampleobject"
  @region "cn-hangzhou"
  @endpoint "oss-#{@region}.aliyuncs.com"
  # official example, maybe wrong
  # @signing_key "3543b7686e65eda71e5e5ca19d548d78423c37e8ddba4dc9d83f90228b457c76"
  # @signature "053edbf550ebd239b32a9cdfd93b0b2b3f2d223083aa61f75e9ac16856d61f23"

  # @signing_key "8a01ff4efcc65ca2cbc75375045c61ab5f3fa8b9a2d84f0add27ef16a25feb3c"
  @signature "d3694c2dfc5371ee6acd35e88c4871ac95a7ba01d3a2f476768fe61218590097"

  setup do
    config =
      Config.new!(%{
        region: @region,
        endpoint: @endpoint,
        access_key_id: @access_key_id,
        access_key_secret: @access_key_secret
      })

    %{config: config}
  end

  describe "sign with header" do
    test "creates a request and sign with header", %{config: config} do
      headers = %{
        "Content-Disposition" => "attachment",
        "content-length" => "3",
        "content-md5" => "ICy5YqxZB1uWSwcVLSNLcA==",
        "content-type" => "text/plain",
        "x-oss-content-sha256" => "UNSIGNED-PAYLOAD",
        "x-oss-date" => "20250411T064124Z"
      }

      authorization =
        "OSS4-HMAC-SHA256 Credential=#{@access_key_id}/20250411/cn-hangzhou/oss/aliyun_v4_request,AdditionalHeaders=content-disposition;content-length,Signature=#{@signature}"

      assert %{
               req: %{
                 headers: %{
                   "authorization" => [^authorization]
                 }
               }
             } =
               Request.build!(config, :put, @bucket, @object, headers, %{})
               |> Request.sign_header()
    end
  end

  @signature "69023ccc03d7fa2ff1571d8bda9c3263ed2d32cc1d2ee431f08aefb43dd2d182"
  @utc_now ~U[2025-07-01 02:44:10Z]
  @today "20250701"
  @timestamp "20250701T024410Z"
  describe "sign with url" do
    test_with_mock "creates a request and sign with url",
                   %{config: config},
                   DateTime,
                   [:passthrough],
                   utc_now: fn :second -> @utc_now end do
      url =
        config
        |> Request.build!(:get, @bucket, @object, %{}, %{})
        |> Request.sign_url()
        |> Request.to_url()

      assert %{
               scheme: "https",
               host: "#{@bucket}.#{@endpoint}",
               path: "/#{@object}",
               query: query
             } = URI.parse(url)

      assert %{
               "x-oss-credential" =>
                 "LTAI****************/#{@today}/cn-hangzhou/oss/aliyun_v4_request",
               "x-oss-date" => @timestamp,
               "x-oss-expires" => "3600",
               "x-oss-signature" => @signature,
               "x-oss-signature-version" => "OSS4-HMAC-SHA256"
             } = URI.decode_query(query)
    end
  end
end
