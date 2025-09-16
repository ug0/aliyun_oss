defmodule AliyunOss.MixProject do
  use Mix.Project

  @source_url "https://github.com/ug0/aliyun_oss"
  @version "3.3.0"

  def project do
    [
      app: :aliyun_oss,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Aliyun.Oss, []},
      extra_applications: [:logger, :eex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.5.12"},
      {:mime, "~> 2.0"},
      {:aliyun_util, "~> 0.4.1"},
      {:elixir_xml_to_map, "~> 3.0"},
      {:jason, "~> 1.1"},
      {:mock, "~> 0.3.0", only: :test},
      {:ex_doc, "~> 0.20", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      description: "Aliyun OSS API(阿里云对象存储 OSS API)",
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "Aliyun.Oss",
      groups_for_modules: [
        Service: [
          Aliyun.Oss.Service
        ],
        Region: [
          Aliyun.Oss.Region
        ],
        Bucket: [
          Aliyun.Oss.Bucket,
          Aliyun.Oss.Bucket.WORM,
          Aliyun.Oss.Bucket.ACL,
          Aliyun.Oss.Bucket.Lifecycle,
          Aliyun.Oss.Bucket.Versioning,
          Aliyun.Oss.Bucket.Replication,
          Aliyun.Oss.Bucket.Policy,
          Aliyun.Oss.Bucket.Inventory,
          Aliyun.Oss.Bucket.Logging,
          Aliyun.Oss.Bucket.Website,
          Aliyun.Oss.Bucket.Referer,
          Aliyun.Oss.Bucket.Tags,
          Aliyun.Oss.Bucket.Encryption,
          Aliyun.Oss.Bucket.RequestPayment,
          Aliyun.Oss.Bucket.CORS
        ],
        Object: [
          Aliyun.Oss.Object,
          Aliyun.Oss.Object.MultipartUpload,
          Aliyun.Oss.Object.ACL,
          Aliyun.Oss.Object.Symlink,
          Aliyun.Oss.Object.Tagging
        ],
        LiveChannel: [
          Aliyun.Oss.LiveChannel
        ],
        "HTTP Client": [
          Aliyun.Oss.Client,
          Aliyun.Oss.Client.Request,
          Aliyun.Oss.Client.Response,
          Aliyun.Oss.Client.Error
        ],
        Configuration: [
          Aliyun.Oss.Config
        ]
      ]
    ]
  end
end
