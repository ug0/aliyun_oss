defmodule Aliyun.Oss.Client.ObjectTest do
  use ExUnit.Case

  import Mock

  alias Aliyun.Oss.Object
  alias Aliyun.Oss.Config

  @access_key_id "LTAI****************"
  @access_key_secret "yourAccessKeySecret"
  @bucket "examplebucket"
  @object "exampleobject"
  @region "cn-hangzhou"
  @endpoint "oss-#{@region}.aliyuncs.com"

  @config Config.new!(%{
            region: @region,
            endpoint: @endpoint,
            access_key_id: @access_key_id,
            access_key_secret: @access_key_secret
          })

  @utc_now ~U[2025-07-01 02:44:10Z]
  @utc_today ~D[2025-07-01]
  @today "20250701"
  @timestamp "20250701T024410Z"
  @expires 3600

  setup_with_mocks([
    {DateTime, [:passthrough], utc_now: fn :second -> @utc_now end},
    {Date, [:passthrough], utc_today: fn -> @utc_today end}
  ]) do
    :ok
  end

  describe "signed_url/4" do
    @signature1 "69023ccc03d7fa2ff1571d8bda9c3263ed2d32cc1d2ee431f08aefb43dd2d182"
    @signature2 "bb11bc405a884f8ca30ae0ca3180e9c16cf10e8499db69e4609335fca7396416"
    test "build signed object url for GET" do
      assert %{
               scheme: "https",
               host: "#{@bucket}.#{@endpoint}",
               path: "/#{@object}",
               query: query
             } = Object.signed_url(@config, @bucket, @object) |> URI.parse()

      assert %{
               "x-oss-credential" =>
                 "LTAI****************/#{@today}/cn-hangzhou/oss/aliyun_v4_request",
               "x-oss-date" => @timestamp,
               "x-oss-expires" => "3600",
               "x-oss-signature" => @signature1,
               "x-oss-signature-version" => "OSS4-HMAC-SHA256"
             } = URI.decode_query(query)

      assert %{
               scheme: "https",
               host: "#{@bucket}.#{@endpoint}",
               path: "/#{@object}",
               query: query
             } =
               Object.signed_url(@config, @bucket, @object, query_params: %{"acl" => nil})
               |> URI.parse()

      assert %{
               "x-oss-credential" =>
                 "LTAI****************/#{@today}/cn-hangzhou/oss/aliyun_v4_request",
               "x-oss-date" => @timestamp,
               "x-oss-expires" => "3600",
               "x-oss-signature" => @signature2,
               "x-oss-signature-version" => "OSS4-HMAC-SHA256"
             } = URI.decode_query(query)
    end

    @signature "c7845a547fbd470020ee8ff22fa03d720e5e1b0e88a1e18de4afc32791fe8285"
    test "build signed object url for PUT" do
      assert %{
               scheme: "https",
               host: "#{@bucket}.#{@endpoint}",
               path: "/#{@object}",
               query: query
             } =
               Object.signed_url(@config, @bucket, @object,
                 expires: @expires,
                 method: :put,
                 headers: %{
                   "Content-Type" => "text/plain"
                 }
               )
               |> URI.parse()

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

  describe "object_url/4" do
    @signature "69023ccc03d7fa2ff1571d8bda9c3263ed2d32cc1d2ee431f08aefb43dd2d182"
    test "build signed object url for downloading" do
      assert %{
               scheme: "https",
               host: "#{@bucket}.#{@endpoint}",
               path: "/#{@object}",
               query: query
             } = Object.object_url(@config, @bucket, @object, @expires) |> URI.parse()

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
               signature: "4f19e5c3030598cfe1d4e34b6006cd931bae28ddd5df481ff175e70e94495793"
             }
    end
  end
end
