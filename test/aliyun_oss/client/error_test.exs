defmodule Aliyun.Oss.Client.ErrorTest do
  use ExUnit.Case
  doctest Aliyun.Oss.Client.Error

  alias Aliyun.Oss.Client.Error

  describe "build/2" do
    test "error body is not xml" do
      assert %Error{
               status: 400,
               message: "invalid_xml"
             } = Error.build(400, "invalid_xml")
    end

    @xml """
    <Result>
      <Code>AccessDenied</Code>
      <Message>The bucket you are attempting to access must be addressed using the specified endpoint. Please send all future requests to this endpoint.</Message>
      <RequestId>5BFCF52FAEFD3AAD7B4D821A</RequestId>
      <HostId>oss-cn-shenzhen.aliyuncs.com</HostId>
      <Bucket>asd</Bucket>
      <Endpoint>oss-cn-hangzhou.aliyuncs.com</Endpoint>
    </Result>
    """
    test "xml body is missing `Error` key" do
      assert %Error{
               status: 400,
               message: @xml,
             } = Error.build(400, @xml)
    end

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
    test "error body is valid xml" do
      assert %Error{
               status: 200,
               code: "AccessDenied",
               message:
                 "The bucket you are attempting to access must be addressed using the specified endpoint. Please send all future requests to this endpoint.",
               details: %{
                 "Code" => "AccessDenied",
                 "Message" =>
                   "The bucket you are attempting to access must be addressed using the specified endpoint. Please send all future requests to this endpoint.",
                 "RequestId" => "5BFCF52FAEFD3AAD7B4D821A",
                 "HostId" => "oss-cn-shenzhen.aliyuncs.com"
               }
             } = Error.build(200, @xml)
    end
  end
end
