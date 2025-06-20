defmodule Aliyun.Oss.Bucket.Replication do
  @moduledoc """
  Bucket operations - Replication.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3]
  import Aliyun.Oss.Service, only: [post: 5]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  PutBucketReplication - configures data replication rules for a bucket.

  ## Examples

      iex> config_json = %{
        "ReplicationConfiguration" => %{
          "Rule" => %{
            "Action" => "ALL",
            "Destination" => %{
              "Bucket" => "replication-test",
              "Location" => "oss-cn-beijing",
              "TransferType" => "internal"
            },
            "HistoricalObjectReplication" => "disabled"
          }
        }
      }
      iex> Aliyun.Oss.Bucket.Replication.put("some-bucket", config_json)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}
      iex> config_xml = ~S[
        <?xml version="1.0" encoding="UTF-8"?>
        <ReplicationConfiguration>
          <Rule>
            <Action>ALL</Action>
            <Destination>
                <Bucket>replication-test</Bucket>
                <Location>oss-cn-beijing</Location>
                <TransferType>internal</TransferType>
            </Destination>
            <HistoricalObjectReplication>disabled</HistoricalObjectReplication>
          </Rule>
        </ReplicationConfiguration>
      ]
      iex> Aliyun.Oss.Bucket.Inventory.put("some-bucket", "inventory_id", config_xml)
      {:ok, %Aliyun.Oss.Client.Response{
        data: "",
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

  """
  @spec put(Config.t(), String.t(), String.t() | map()) :: {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, %{} = config) do
    put(config, bucket, MapToXml.from_map(config))
  end

  def put(config, bucket, config) do
    post(config, bucket, nil, config, sub_resources: %{"replication" => nil, "comp" => "add"})
  end

  @doc """
  GetBucketReplication - gets cross-region replication (CRR) rules configured for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Replication.get("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "ReplicationConfiguration" => %{
            "Rule" => %{
              "Action" => "ALL",
              "Destination" => %{
                "Bucket" => "replication-test",
                "Location" => "oss-cn-beijing"
              },
              "HistoricalObjectReplication" => "disabled",
              "ID" => "test_replication_1",
              "Status" => "starting"
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
    get_bucket(config, bucket, %{"replication" => nil})
  end

  @doc """
  GetBucketReplicationLocation - gets the region in which the destination bucket can be located.

  ## Examples

      iex> Aliyun.Oss.Bucket.Replication.get_location("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "ReplicationLocation" => %{
            "Location" => ["oss-ap-northeast-1", "oss-ap-south-1",
              "oss-ap-southeast-1", "oss-ap-southeast-2", "oss-ap-southeast-3",
              "oss-ap-southeast-5", "oss-cn-beijing", "oss-cn-chengdu",
              "oss-cn-guangzhou", "oss-cn-hangzhou", "oss-cn-heyuan",
              "oss-cn-hongkong", "oss-cn-huhehaote", "oss-cn-qingdao",
              "oss-cn-shanghai", "oss-cn-wulanchabu", "oss-cn-zhangjiakou",
              "oss-eu-central-1", "oss-eu-west-1", "oss-me-east-1", "oss-rus-west-1",
              "oss-us-east-1", "oss-us-west-1"],
            "LocationTransferTypeConstraint" => %{
              "LocationTransferType" => [
                %{
                  "Location" => "oss-cn-hongkong",
                  "TransferTypes" => %{"Type" => "oss_acc"}
                },
                # ...
              ]
            }
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

  """
  @spec get_location(Config.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_location(config, bucket) do
    get_bucket(config, bucket, %{"replicationLocation" => nil})
  end

  @doc """
  GetBucketReplicationProgress - gets the progress of a data replication task configured for a bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Replication.get_progress("some-bucket", "replication_rule_id_1")
      {:ok, %Aliyun.Oss.Client.Response{
        data: %{
          "ReplicationProgress" => %{
            "Rule" => %{
              "Action" => "ALL",
              "Destination" => %{
                "Bucket" => "replication-test",
                "Location" => "oss-cn-beijing"
              },
              "HistoricalObjectReplication" => "disabled",
              "ID" => "replication_rule_id_1",
              "Progress" => %{"NewObject" => "2021-01-19T05:53:07.000Z"},
              "Status" => "doing"
            }
          }
        },
        headers: [
          {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
          ...
        ]
      }}

  """
  @spec get_progress(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_progress(config, bucket, rule_id) do
    get_bucket(config, bucket, %{"rule-id" => rule_id, "replicationProgress" => nil})
  end

  @doc """
  DeleteBucketReplication - disables data replication for a bucket and delete the data replication
  rule configured for the bucket.

  ## Examples

      iex> Aliyun.Oss.Bucket.Replication.delete("some-bucket", "rule1")
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
  @body_tmpl """
  <?xml version="1.0" encoding="UTF-8"?>
  <ReplicationRules>
    <ID><%= rule_id %></ID>
  </ReplicationRules>
  """
  @spec delete(Config.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Aliyun.Oss.Client.Response.t()}
  def delete(config, bucket, rule_id) do
    body_xml = EEx.eval_string(@body_tmpl, rule_id: rule_id)

    post(config, bucket, nil, body_xml, sub_resources: %{"replication" => nil, "comp" => "delete"})
  end
end
