defmodule Aliyun.Oss.Region do
  @moduledoc """
  Region operations
  """

  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.Response

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
          status: 404,
          code: "NoSuchRegion",
          message: "unknown",
          details: %{
            "Code" => "NoSuchRegion",
            "HostId" => "oss-cn-hangzhou.aliyuncs.com",
            "Message" => "unknown",
            "Region" => "unknown",
            "RequestId" => "5BFF89955E29FF66F10B9763"
          }
        }
      }

  """
  @spec describe_regions(Config.t(), String.t() | nil) ::
          {:error, Exception.t()} | {:ok, Response.t()}
  def describe_regions(%Config{} = config, region_id \\ nil) do
    Service.get(config, nil, nil, query_params: %{"regions" => region_id})
  end
end
