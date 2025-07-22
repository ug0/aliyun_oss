defmodule Aliyun.Oss.Region do
  @moduledoc """
  Region operations
  """

  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.{Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  DescribeRegions - lists the region information.

  ## Examples

      iex> Aliyun.Oss.Region.describe_regions(config)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "RegionInfoList" => %{
              "RegionInfo" => [
                %{
                  "AccelerateEndpoint" => "oss-accelerate.aliyuncs.com",
                  "InternalEndpoint" => "oss-cn-guangzhou-internal.aliyuncs.com",
                  "InternetEndpoint" => "oss-cn-guangzhou.aliyuncs.com",
                  "Region" => "oss-cn-guangzhou"
                },
                %{
                  "AccelerateEndpoint" => "oss-accelerate.aliyuncs.com",
                  "InternalEndpoint" => "oss-cn-hangzhou-internal.aliyuncs.com",
                  "InternetEndpoint" => "oss-cn-hangzhou.aliyuncs.com",
                  "Region" => "oss-cn-hangzhou"
                },
                ...
              ]
            }
          },
          headers: %{
            "connection"=> ["keep-alive"],
            ...
          }
        }
      }
      iex> Aliyun.Oss.Region.describe_regions(config, "oss-cn-hangzhou)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "RegionInfoList" => %{
              "RegionInfo" => %{
                "AccelerateEndpoint" => "oss-accelerate.aliyuncs.com",
                "InternalEndpoint" => "oss-cn-hangzhou-internal.aliyuncs.com",
                "InternetEndpoint" => "oss-cn-hangzhou.aliyuncs.com",
                "Region" => "oss-cn-hangzhou"
              }
            }
          },
          headers: %{
            "connection"=> ["keep-alive"],
            ...
          }
        }
      }
      iex> Aliyun.Oss.Region.describe_regions(config, "unknown")
      {:error,
        %Aliyun.Oss.Client.Error{
          status_code: 404,
          parsed_details: %{
            "ListBucketResult" => %{
              "Code" => "NoSuchRegion",
              "HostId" => "oss-cn-hangzhou.aliyuncs.com",
              "Message" => "Unknown",
              "Region" => "unknown",
              "RequestId" => "5BFF89955E29FF66F10B9763"
            }
          },
          body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...</xml>"
        }
      }

  """
  @spec describe_regions(Config.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def describe_regions(%Config{} = config, region_id \\ nil) do
    Service.get(config, nil, nil, query_params: %{"regions" => region_id})
  end
end
