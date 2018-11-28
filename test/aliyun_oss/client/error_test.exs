defmodule Aliyun.Oss.Client.ErrorTest do
  use ExUnit.Case
  doctest Aliyun.Oss.Client.Error


  alias Aliyun.Oss.Client.Error

  describe "parse_xml!/1" do
    @xml """
    <Error>
      <Code>AccessDenied</Code>
      <Message>The bucket you are attempting to access must be addressed using the specified endpoint. Please send all future requests to this endpoint.</Message>
      <RequestId>5BFCF52FAEFD3AAD7B4D821A</RequestId>
      <HostId>oss-cn-shenzhen.aliyuncs.com</HostId>
      <Bucket>asd</Bucket>
      <Endpoint>oss-cn-hangzhou.aliyuncs.com</Endpoint>
    </Error>
    """
    test "build the complete query url" do
      assert %{
        "Code" => "AccessDenied",
        "Message" => "The bucket you are attempting to access must be addressed using the specified endpoint. Please send all future requests to this endpoint.",
        "RequestId" => "5BFCF52FAEFD3AAD7B4D821A",
        "HostId" => "oss-cn-shenzhen.aliyuncs.com",
      } = Error.parse_xml!(@xml)
    end
  end
end
