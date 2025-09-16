defmodule Aliyun.Oss.Bucket.RequestPayment do
  @moduledoc """
  Bucket operations - RequestPayment.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.Response

  @doc """
  GetBucketRequestPayment - gets pay-by-requester configurations for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.RequestPayment.get(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"RequestPaymentConfiguration" => %{"Payer" => "BucketOwner"}},
          headers: %{
            "connection" => ["keep-alive"],
            ...
          }
        }
      }

  """
  @spec get(Config.t(), String.t()) :: {:error, Exception.t()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, query_params: %{"requestPayment" => nil})
  end

  @doc """
  PutBucketRequestPayment - enables pay-by-requester for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.RequestPayment.put(config, "some-bucket", "Requester")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Wed, 09 Jul 2025 07:12:09 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686E164922DB************"],
          "x-oss-server-time" => ["81"]
          }
        }
      }

  """
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <RequestPaymentConfiguration>
    <Payer><%= payer %></Payer>
  </RequestPaymentConfiguration>
  """
  @spec put(Config.t(), String.t(), String.t()) :: {:error, Exception.t()} | {:ok, Response.t()}
  def put(config, bucket, payer) do
    xml_body = EEx.eval_string(@body_tmpl, payer: payer)
    put_bucket(config, bucket, xml_body, query_params: %{"requestPayment" => nil})
  end
end
