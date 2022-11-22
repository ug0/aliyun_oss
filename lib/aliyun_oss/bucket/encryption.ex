defmodule Aliyun.Oss.Bucket.Encryption do
  @moduledoc """
  Bucket operations - Encryption.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 4, put_bucket: 5, delete_bucket: 3]
  alias Aliyun.Oss.ConfigAlt, as: Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketEncryption - gets the encryption rules configured for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Encryption.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "ServerSideEncryptionRule" => %{
            "ApplyServerSideEncryptionByDefault" => %{
              "SSEAlgorithm" => "AES256"
            }
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, %{}, %{"encryption" => nil})
  end

  @doc """
  PutBucketEncryption - configures encryption rules for a bucket.

  ## Options

  - `:algorithm` - Accept value: `:aes256`, `:kms`, default is `:aes256`
  - `:kms_master_key_id` - Should and only be set if algorithm is `:kms`

  ## Examples

      iex> Aliyun.Oss.Bucket.Encryption.put("some-bucket", algorithm: :aes256)
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:05:50 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C0000000000000000000000"},
          {"x-oss-server-time", "63"}
        ]
      }}

  """
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <ServerSideEncryptionRule>
    <ApplyServerSideEncryptionByDefault>
      <SSEAlgorithm><%= algorithm %></SSEAlgorithm>
      <KMSMasterKeyID><%= kms_master_key_id %></KMSMasterKeyID>
    </ApplyServerSideEncryptionByDefault>
  </ServerSideEncryptionRule>
  """
  @spec put(Config.t(), String.t(), Keyword.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put(config, bucket, opts \\ []) do
    {algorithm, kms_master_key_id} =
      case Keyword.get(opts, :algorithm, :aes256) do
        :aes256 -> {"AES256", nil}
        :kms -> {"KMS", Keyword.fetch!(opts, :kms_master_key_id)}
      end

    xml_body =
      EEx.eval_string(
        @body_tmpl,
        algorithm: algorithm,
        kms_master_key_id: kms_master_key_id
      )

    put_bucket(config, bucket, %{}, %{"encryption" => nil}, xml_body)
  end

  @doc """
  DeleteBucketEncryption - deletes encryption rules configured for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Encryption.delete("some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Server", "AliyunOSS"},
          {"Date", "Fri, 11 Jan 2019 05:19:45 GMT"},
          {"Content-Length", "0"},
          {"Connection", "keep-alive"},
          {"x-oss-request-id", "5C3000000000000000000000"},
          {"x-oss-server-time", "90"}
        ]
      }}

  """
  @spec delete(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket) do
    delete_bucket(config, bucket, %{"encryption" => nil})
  end
end
