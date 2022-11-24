defmodule Aliyun.Oss.Bucket.RequestPayment do
  @moduledoc """
  Bucket operations - RequestPayment.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 4, put_bucket: 5]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketRequestPayment - gets pay-by-requester configurations for a bucket.

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
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, %{}, %{"requestPayment" => nil})
  end

  @doc """
  PutBucketRequestPayment - enables pay-by-requester for a bucket.

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
  @spec put(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, payer) do
    xml_body = EEx.eval_string(@body_tmpl, payer: payer)
    put_bucket(config, bucket, %{}, %{"requestPayment" => nil}, xml_body)
  end
end
