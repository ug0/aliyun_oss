defmodule Aliyun.Oss.Bucket.Logging do
  @moduledoc """
  Bucket Inventory - Logging.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3, put_bucket: 4, delete_bucket: 3]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  GetBucketLogging - gets the access logging configuration of a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Logging.get(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "BucketLoggingStatus" => %{
            "LoggingEnabled" => %{
              "TargetBucket" => "some-bucket",
              "TargetPrefix" => "oss-accesslog/"
            }
          }
        },
        headers: %{
          "connection" => "keep-alive",
          ...
        }
      }}

  """
  @spec get(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get(config, bucket) do
    get_bucket(config, bucket, query_params: %{"logging" => nil})
  end

  @doc """
  PutBucketLogging - enables logging for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Logging.put(config, "some-bucket", "target-bucket", "target-prefix")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Wed, 09 Jul 2025 02:04:19 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686DCE23993*************"],
          "x-oss-server-time" => ["175"]
        }
      }}

  """

  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <BucketLoggingStatus>
    <LoggingEnabled>
      <TargetBucket><%= target_bucket %></TargetBucket>
      <TargetPrefix><%= target_prefix %></TargetPrefix>
    </LoggingEnabled>
  </BucketLoggingStatus>
  """
  @spec put(Config.t(), String.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put(config, bucket, target_bucket, target_prefix \\ "oss-accesslog/") do
    body =
      EEx.eval_string(
        @body_tmpl,
        target_bucket: target_bucket,
        target_prefix: target_prefix
      )

    put_bucket(config, bucket, body, query_params: %{"logging" => nil})
  end

  @doc """
  DeleteBucketLogging - deletes the logging configurations for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Logging.delete(config, "some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Wed, 09 Jul 2025 02:09:12 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686DCF4768CD************"],
          "x-oss-server-time" => ["408"]
        }
      }}
      iex> Aliyun.Oss.Bucket.Logging.delete(config, "unknown-bucket")
      {:error,
      %Aliyun.Oss.Client.Error{
        parsed_details: %{
          "BucketName" => "unknown-bucket",
          "Code" => "NoSuchBucket",
          "EC" => "0015-00000101",
          "HostId" => "unknown-bucket.oss-cn-shenzhen.aliyuncs.com",
          "Message" => "The specified bucket does not exist.",
          "RecommendDoc" => "https://api.aliyun.com/troubleshoot?q=0015-00000101",
          "RequestId" => "5C38283EC84D1C4471F2F48A"
        },
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>",
        status_code: 404
      }}

  """
  @spec delete(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket) do
    delete_bucket(config, bucket, query_params: %{"logging" => nil})
  end

  @doc """
  PutUserDefinedLogFieldsConfig

  ## Examples

      iex> Aliyun.Oss.Bucket.Logging.put_user_defined_log_fields_config(config, "some-bucket", "target-bucket", ["header1", "header2"], ["param1", "param2"])
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Wed, 09 Jul 2025 02:20:55 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686DD2072A7*************"],
          "x-oss-server-time" => ["54"]
        }
      }}

  """

  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <UserDefinedLogFieldsConfiguration>
    <HeaderSet>
      <%= for header <- headers do %>
        <header><%= header %></header>
      <% end %>
    </HeaderSet>
    <ParamSet>
      <%= for param <- params do %>
        <parameter><%= param %></parameter>
      <% end %>
    </ParamSet>
  </UserDefinedLogFieldsConfiguration>
  """
  @spec put_user_defined_log_fields_config(Config.t(), String.t(), list(), list()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def put_user_defined_log_fields_config(config, bucket, headers, params) do
    body =
      EEx.eval_string(
        @body_tmpl,
        headers: headers,
        params: params
      )

    put_bucket(config, bucket, body, query_params: %{"userDefinedLogFieldsConfig" => nil})
  end

  @doc """
  GetUserDefinedLogFieldsConfig

  ## Examples

      iex> Aliyun.Oss.Bucket.Logging.get_user_defined_log_fields_config(config, "some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "UserDefinedLogFieldsConfiguration" => %{
            "HeaderSet" => %{"header" => ["header1", "header2"]},
            "ParamSet" => %{"parameter" => ["param1", "param2"]}
          }
        },
        headers: %{
          "connection" => "keep-alive",
          ...
        }
      }}

  """
  @spec get_user_defined_log_fields_config(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_user_defined_log_fields_config(config, bucket) do
    get_bucket(config, bucket, query_params: %{"userDefinedLogFieldsConfig" => nil})
  end

  @doc """
  DeleteUserDefinedLogFieldsConfig

  ## Examples

      iex> Aliyun.Oss.Bucket.Logging.delete_user_defined_log_fields_config(config, "some-bucket")
      {:ok,
      %Aliyun.Oss.Client.Response{
        data: "",
        headers: %{
          "connection" => ["keep-alive"],
          "content-length" => ["0"],
          "date" => ["Wed, 09 Jul 2025 02:09:12 GMT"],
          "server" => ["AliyunOSS"],
          "x-oss-request-id" => ["686DCF4768CD************"],
          "x-oss-server-time" => ["408"]
        }
      }}

  """
  @spec delete_user_defined_log_fields_config(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete_user_defined_log_fields_config(config, bucket) do
    delete_bucket(config, bucket, query_params: %{"userDefinedLogFieldsConfig" => nil})
  end
end
