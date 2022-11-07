defmodule Aliyun.Oss.Bucket.RequestPayment do
  @moduledoc """
  Bucket RequestPayment 相关操作
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4]

  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketRequestPayment接口用于获取请求者付费模式配置信息。

  ## Examples

      iex> Aliyun.Oss.Bucket.RequestPayment.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"RequestPaymentConfiguration" => %{"Payer" => "BucketOwner"}},
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Fri, 01 Mar 2019 06:26:07 GMT"},
            ...
          ]
        }
      }
  """
  @spec get(String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(bucket) do
    get_bucket(bucket, %{}, %{"requestPayment" => nil})
  end

  @doc """
  PutBucketRequestPayment接口用于设置请求者付费模式。

  ## Examples

      iex> Aliyun.Oss.Bucket.RequestPayment.put("some-bucket", "Requester)
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Fri, 01 Mar 2019 06:26:07 GMT"},
            ...
          ]
        }
      }
  """
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <RequestPaymentConfiguration>
    <Payer><%= payer %></Payer>
  </RequestPaymentConfiguration>
  """
  @spec put(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def put(bucket, payer) do
    xml_body = EEx.eval_string(@body_tmpl, payer: payer)
    put_bucket(bucket, %{}, %{"requestPayment" => nil}, xml_body)
  end
end
