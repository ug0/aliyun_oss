defmodule Aliyun.Oss.Client.ErrorTest do
  use ExUnit.Case
  doctest Aliyun.Oss.Client.Error

  alias Aliyun.Oss.Client.Error

  describe "parse_error/1" do
    test "error body is not xml" do
      assert %Error{
               status_code: 400,
               body: "invalid xml"
             } = Error.parse(%Error{body: "invalid xml", status_code: 400})
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
               status_code: 200,
               parsed_details: %{
                 "Code" => "AccessDenied",
                 "Message" =>
                   "The bucket you are attempting to access must be addressed using the specified endpoint. Please send all future requests to this endpoint.",
                 "RequestId" => "5BFCF52FAEFD3AAD7B4D821A",
                 "HostId" => "oss-cn-shenzhen.aliyuncs.com"
               }
             } = Error.parse(%Error{body: @xml, status_code: 200})
    end
  end
end
