defmodule Aliyun.Oss.Config do
  def endpoint do
    Application.get_env(:aliyun_oss, :endpoint)
  end

  def access_key_id do
    Application.get_env(:aliyun_oss, :access_key_id)
  end

  def access_key_secret do
    Application.get_env(:aliyun_oss, :access_key_secret)
  end
end
