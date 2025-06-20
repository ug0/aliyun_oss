defmodule Aliyun.Oss.LiveChannel do
  @moduledoc """
  LiveChannel-related operations.
  """

  import Aliyun.Oss.Bucket, only: [get_bucket: 3]
  import Aliyun.Oss.Object, only: [put_object: 6, get_object: 5, delete_object: 4]
  alias Aliyun.Oss.Config
  alias Aliyun.Oss.Service
  alias Aliyun.Oss.Client.{Request, Response, Error}

  @type error() ::
          %Error{body: String.t(), status_code: integer(), parsed_details: map()} | atom()

  @doc """
  Creates a signed RTMP ingest URL.

  ## Examples

      iex> expires = Timex.now() |> Timex.shift(days: 1) |> Timex.to_unix()
      iex> Aliyun.Oss.Object.signed_url("some-bucket", "some-object", expires, "GET", %{"Content-Type" -> ""})
      "http://some-bucket.oss-cn-hangzhou.aliyuncs.com/oss-api.pdf?OSSAccessKeyId=nz2pc5*******9l&Expires=1141889120&Signature=vjbyPxybdZ*****************v4%3D"

  """
  @spec signed_publish_url(Config.t(), String.t(), String.t(), integer(), map()) :: String.t()
  def signed_publish_url(
        config,
        bucket,
        channel,
        expires,
        query_params \\ %{"playlistName" => "playlist.m3u8"}
      ) do
    request =
      Request.build(%{
        host: "#{bucket}.#{config.endpoint}",
        path: "/live/#{channel}",
        resource: "/#{bucket}/#{channel}",
        scheme: "rtmp",
        query_params: query_params,
        expires: expires
      })

    Request.to_signed_url(config, request)
  end

  @doc """
  PutLiveChannel - creates a LiveChannel.

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
  @spec put(Config.t(), String.t(), String.t(), map() | String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def put(config, bucket, channel_name, %{} = config) do
    put(config, bucket, channel_name, MapToXml.from_map(config))
  end

  def put(config, bucket, channel_name, config) do
    put_object(config, bucket, channel_name, config, %{}, %{"live" => nil})
  end

  @doc """
  ListLiveChannel - lists specified LiveChannels.

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
  @spec list(Config.t(), String.t(), map()) :: {:error, error()} | {:ok, Response.t()}
  def list(config, bucket, query_params \\ %{}) do
    get_bucket(config, bucket, Map.put(query_params, "live", nil))
  end

  @doc """
  DeleteLiveChannel - deletes a specified LiveChannel.

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
  @spec delete(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def delete(config, bucket, channel_name) do
    delete_object(config, bucket, channel_name, %{"live" => nil})
  end

  @doc """
  PutLiveChannelStatus - sets a LiveChannel to one of the states - enabled or disabled.

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
  @spec put_status(Config.t(), String.t(), String.t(), String.t()) ::
          {:error, error()} | {:ok, Response.t()}
  def put_status(config, bucket, channel_name, status) do
    put_object(config, bucket, channel_name, "", %{}, %{"live" => nil, "status" => status})
  end

  @doc """
  GetLiveChannelInfo - gets the configuration information about a specified LiveChannel.

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
  @spec get_info(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_info(config, bucket, channel_name) do
    get_object(config, bucket, channel_name, %{}, %{"live" => nil})
  end

  @doc """
  GetLiveChannelStat - gets the stream ingestion status of a specified LiveChannel.

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
  @spec get_stat(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_stat(config, bucket, channel_name) do
    get_object(config, bucket, channel_name, %{}, %{"live" => nil, "comp" => "stat"})
  end

  @doc """
  GetLiveChannelHistory - gets the stream pushing record of a LiveChannel.

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
  @spec get_history(Config.t(), String.t(), String.t()) :: {:error, error()} | {:ok, Response.t()}
  def get_history(config, bucket, channel_name) do
    get_object(config, bucket, channel_name, %{}, %{"live" => nil, "comp" => "history"})
  end

  @doc """
  PostVodPlaylist - generates a VOD playlist for the specified LiveChannel.

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
  @spec post_playlist(Config.t(), String.t(), String.t(), String.t(), integer(), integer()) ::
          {:error, error()} | {:ok, Response.t()}
  def post_playlist(config, bucket, channel_name, list_name, start_time, end_time) do
    Service.post(config, bucket, "#{channel_name}/#{list_name}", "",
      sub_resources: %{"vod" => nil, "startTime" => start_time, "endTime" => end_time}
    )
  end

  @doc """
  GetVodPlaylist - gets the playlist generated by the streams pushed to a specified LiveChannel in a specified time period.

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
  @spec get_playlist(Config.t(), String.t(), String.t(), integer(), integer()) ::
          {:error, error()} | {:ok, Response.t()}
  def get_playlist(config, bucket, channel_name, start_time, end_time) do
    get_object(config, bucket, channel_name, %{}, %{
      "vod" => nil,
      "startTime" => start_time,
      "endTime" => end_time
    })
  end
end
