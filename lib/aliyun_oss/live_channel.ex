defmodule Aliyun.Oss.LiveChannel do
  @moduledoc """
  LiveChannel 相关操作:
    - `Aliyun.Oss.LiveChannel`: LiveChannel 基本操作
  """

  import Aliyun.Oss.Config, only: [endpoint: 0]
  import Aliyun.Oss.Bucket, only: [get_bucket: 3]
  import Aliyun.Oss.Object, only: [put_object: 5, get_object: 4, delete_object: 3]

  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.{Request, Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  生成包含签名的 RTMP 推流地址

  ## Examples

      iex> expires = Timex.now() |> Timex.shift(days: 1) |> Timex.to_unix()
      iex> Aliyun.Oss.Object.signed_url("some-bucket", "some-object", expires, "GET", %{"Content-Type" -> ""})
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc5*******9l&Expires=1141889120&Signature=vjbyPxybdZ*****************v4%3D"
  """
  @spec signed_publish_url(String.t(), String.t(), integer(), map()) :: String.t()
  def signed_publish_url(
        bucket,
        channel,
        expires,
        query_params \\ %{"playlistName" => "playlist.m3u8"}
      ) do
    %{
      host: "#{bucket}.#{endpoint()}",
      path: "/live/#{channel}",
      resource: "/#{bucket}/#{channel}",
      scheme: "rtmp",
      query_params: query_params,
      expires: expires
    }
    |> Request.build()
    |> Request.signed_query_url()
  end

  @doc """
  通过RTMP协议上传音视频数据前，必须先调用该接口创建一个LiveChannel。调用PutLiveChannel接口会返回RTMP推流地址，以及对应的播放地址。

  ## Examples

      iex> config_json = %{
        "LiveChannelConfiguration" => %{
          "Description" => nil,
          "Status" => "enabled",
          "Target" => %{"FragCount" => "3", "FragDuration" => "2", "Type" => "HLS"}
        }
      }
      iex> Aliyun.Oss.LiveChannel.put("some-bucket", "channe-name", config_json)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CreateLiveChannelResult" => %{
              "PlayUrls" => %{
                "Url" => "http://some-bucket.oss-cn-shenzhen.aliyuncs.com/channel-name/playlist.m3u8"
              },
              "PublishUrls" => %{
                "Url" => "rtmp://some-bucket.oss-cn-shenzhen.aliyuncs.com/live/channel-name"
              }
            }
          },
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
      iex> config_xml = ~S[
        <?xml version="1.0" encoding="UTF-8"?>
        <LiveChannelConfiguration>
          <Description></Description>
          <Status>enabled</Status>
          <Target>
            <FragCount>3</FragCount>
            <FragDuration>2</FragDuration>
            <Type>HLS</Type>
          </Target>
        </LiveChannelConfiguration>
      ]
      iex> Aliyun.Oss.LiveChannel.put("some-bucket", "channe-name", config_xml)
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "CreateLiveChannelResult" => %{
              "PlayUrls" => %{
                "Url" => "http://some-bucket.oss-cn-shenzhen.aliyuncs.com/channel-name/playlist.m3u8"
              },
              "PublishUrls" => %{
                "Url" => "rtmp://some-bucket.oss-cn-shenzhen.aliyuncs.com/live/channel-name"
              }
            }
          },
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec put(String.t(), String.t(), map() | String.t()) :: {:error, error()} | {:ok, Response.t()}
  def put(bucket, channel_name, %{} = config) do
    put(bucket, channel_name, MapToXml.from_map(config))
  end

  def put(bucket, channel_name, config) do
    put_object(bucket, channel_name, config, %{}, %{"live" => nil})
  end

  @doc """
  ListLiveChannel接口用于列举指定的LiveChannel。

  ## Examples

      iex> Aliyun.Oss.LiveChannel.list("some-bucket")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "ListLiveChannelResult" => %{
              "IsTruncated" => false,
              "LiveChannel" => [
                %{
                  "Description" => nil,
                  "LastModified" => "2021-01-20T03:18:06.000Z",
                  "Name" => "channel1",
                  "PlayUrls" => %{
                    "Url" => "http://some-bucket.oss-cn-shenzhen.aliyuncs.com/channel1/playlist.m3u8"
                  },
                  "PublishUrls" => %{
                    "Url" => "rtmp://some-bucket.oss-cn-shenzhen.aliyuncs.com/live/channel1"
                  },
                  "Status" => "enabled"
                },
                # ..
              ],
              "Marker" => nil,
              "MaxKeys" => 2,
              "NextMarker" => nil,
              "Prefix" => nil
            }
          },
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec list(String.t(), map()) :: {:error, error()} | {:ok, Response.t()}
  def list(bucket, query_params \\ %{}) do
    get_bucket(bucket, query_params, %{"live" => nil})
  end

  @doc """
  DeleteLiveChannel接口用于删除指定的LiveChannel。

  ## Examples

      iex> Aliyun.Oss.LiveChannel.delete("some-bucket", "channel-name")
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec delete(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def delete(bucket, channel_name) do
    delete_object(bucket, channel_name, %{"live" => nil})
  end

  @doc """
  LiveChannel分为启用（enabled）和禁用（disabled）两种状态。您可以使用PutLiveChannelStatus接口在两种状态之间进行切换。

  ## Examples

      iex> Aliyun.Oss.LiveChannel.put_status("some-bucket", "channe-name", "disabled)
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec put_status(String.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def put_status(bucket, channel_name, status) do
    put_object(bucket, channel_name, "", %{}, %{"live" => nil, "status" => status})
  end

  @doc """
  GetLiveChannelInfo接口用于获取指定LiveChannel的配置信息。

  ## Examples

      iex> Aliyun.Oss.LiveChannel.get_info("some-bucket", "channe-name")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{
            "LiveChannelConfiguration" => %{
              "Description" => nil,
              "Status" => "enabled",
              "Target" => %{
                "FragCount" => "3",
                "FragDuration" => "2",
                "PlaylistName" => "playlist.m3u8",
                "Type" => "HLS"
              }
            }
          },
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec get_info(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_info(bucket, channel_name) do
    get_object(bucket, channel_name, %{}, %{"live" => nil})
  end

  @doc """
  GetLiveChannelStat接口用于获取指定LiveChannel的推流状态信息。

  ## Examples

      iex> Aliyun.Oss.LiveChannel.get_stat("some-bucket", "channe-name")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"LiveChannelStat" => %{"Status" => "Idle"}},
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec get_stat(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_stat(bucket, channel_name) do
    get_object(bucket, channel_name, %{}, %{"live" => nil, "comp" => "stat"})
  end

  @doc """
  GetLiveChannelHistory接口用于获取指定LiveChannel的推流记录。使用GetLiveChannelHistory接口最多会返回指定LiveChannel最近的10次推流记录。

  ## Examples

      iex> Aliyun.Oss.LiveChannel.get_history("some-bucket", "channe-name")
      {:ok, %Aliyun.Oss.Client.Response{
          data: %{"LiveChannelHistory" => %{
            "LiveRecord" => [
              # ...
            ]
          }},
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec get_history(String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_history(bucket, channel_name) do
    get_object(bucket, channel_name, %{}, %{"live" => nil, "comp" => "history"})
  end

  @doc """
  PostVodPlaylist接口用于为指定的LiveChannel生成一个点播用的播放列表。OSS会查询指定时间范围内由该LiveChannel推流生成的ts文件，并将其拼装为一个m3u8播放列表。

  ## Examples

      iex> Aliyun.Oss.LiveChannel.post_playlist("some-bucket", "channe-name", "list.m3u8", 1472020031, 1472020226)
      {:ok, %Aliyun.Oss.Client.Response{
          data: "",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec post_playlist(String.t(), String.t(), String.t(), integer(), integer()) ::
          {:error, error()} | {:ok, Response.t()}
  def post_playlist(bucket, channel_name, list_name, start_time, end_time) do
    Service.post(bucket, "#{channel_name}/#{list_name}", "",
      sub_resources: %{"vod" => nil, "startTime" => start_time, "endTime" => end_time}
    )
  end

  @doc """
  GetVodPlaylist接口用于查看指定LiveChannel在指定时间段内推流生成的播放列表。

  ## Examples

      iex> Aliyun.Oss.LiveChannel.get_playlist("some-bucket", "channe-name", 1472020031, 1472020226)
      {:ok, %Aliyun.Oss.Client.Response{
          data: "#EXTM3u...",
          headers: [
            {"Server", "AliyunOSS"},
            {"Date", "Wed, 05 Dec 2018 02:34:57 GMT"},
            ...
          ]
        }
      }
  """
  @spec get_playlist(String.t(), String.t(), integer(), integer()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_playlist(bucket, channel_name, start_time, end_time) do
    get_object(bucket, channel_name, %{}, %{
      "vod" => nil,
      "startTime" => start_time,
      "endTime" => end_time
    })
  end
end
