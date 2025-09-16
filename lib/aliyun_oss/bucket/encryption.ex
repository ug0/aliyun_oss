defmodule Aliyun.Oss.Bucket.Encryption do
  @moduledoc """
  Bucket operations - Encryption.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 3]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.Response

  @doc """
  GetBucketEncryption - gets the encryption rules configured for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Encryption.get(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "ServerSideEncryptionRule" => %{
            "ApplyServerSideEncryptionByDefault" => %{
              "SSEAlgorithm" => "AES256"
            }
          }
        },
        headers: %{
          "connection" => ["keep-alive"],
          ...
        }
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, Exception.t()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, query_params: %{"encryption" => nil})
  end

  @doc """
  PutBucketEncryption - configures encryption rules for a bucket.

  ## Options

  - `:algorithm` - Accept value: `:aes256`, `:kms`, `:sm4`, default is `:aes256`
  - `:kms_master_key_id` - Should and only be set if `algorithm` is `:kms`
  - `:kms_data_encryption` - Accept value: `:sm4`, Should and only be set if `algorithm` is `:kms`

  ## Examples

      iex> Aliyun.Oss.Bucket.Encryption.put(config, "some-bucket", algorithm: :aes256)
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Wed, 09 Jul 2025 06:44:24 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686E0FC88A**************"],
          "x-oss-server-time" => ["50"]
        }
      }}

  """
  @algorithms [:aes256, :kms, :sm4]
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <ServerSideEncryptionRule>
    <ApplyServerSideEncryptionByDefault>
      <SSEAlgorithm><%= @algorithm %></SSEAlgorithm>
      <%= if assigns[:kms_data_encryption] do %>
      <KMSDataEncryption><%= @kms_data_encryption %></KMSDataEncryption>
      <% end %>
      <KMSMasterKeyID><%= @kms_master_key_id %></KMSMasterKeyID>
    </ApplyServerSideEncryptionByDefault>
  </ServerSideEncryptionRule>
  """
  @spec put(Config.t(), String.t(), Keyword.t()) ::
          {:error, Exception.t()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put(config, bucket, opts \\ []) do
    vars =
      [algorithm: :aes256, kms_master_key_id: nil]
      |> Keyword.merge(opts)
      |> Enum.reduce([], fn
        {:algorithm, algorithm}, acc when algorithm in @algorithms ->
          [{:algorithm, algorithm |> to_string() |> String.upcase()} | acc]

        {:kms_master_key_id, key}, acc ->
          [{:kms_master_key_id, key} | acc]

        {:kms_data_encryption, :sm4}, acc ->
          [{:kms_data_encryption, "SM4"} | acc]
      end)

    xml_body = EEx.eval_string(@body_tmpl, assigns: vars)
    put_bucket(config, bucket, xml_body, query_params: %{"encryption" => nil})
  end

  @doc """
  DeleteBucketEncryption - deletes encryption rules configured for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Encryption.delete(config, "some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Wed, 09 Jul 2025 06:44:24 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686E0FC88A**************"],
          "x-oss-server-time" => ["50"]
        }
      }}

  """
  @spec delete(Config.t(), String.t()) ::
          {:error, Exception.t()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket) do
    delete_bucket(config, bucket, query_params: %{"encryption" => nil})
  end
end
