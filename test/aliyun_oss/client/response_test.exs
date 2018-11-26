defmodule Aliyun.Oss.Client.ResponseTest do
  use ExUnit.Case
  doctest Aliyun.Oss.Client.Response


  alias Aliyun.Oss.Client.Response

  describe "parse_error/1" do
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
        code: 'AccessDenied',
        message: 'The bucket you are attempting to access must be addressed using the specified endpoint. Please send all future requests to this endpoint.',
        request_id: '5BFCF52FAEFD3AAD7B4D821A',
        host_id: 'oss-cn-shenzhen.aliyuncs.com',
      } = Response.parse_error(@xml)
    end
  end
end
