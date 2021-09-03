defmodule AliyunOss.MixProject do
  use Mix.Project

  def project do
    [
      app: :aliyun_oss,
      version: "1.0.2",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
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
      {:mime, "~> 2.0"},
      {:aliyun_util, "~> 0.3.3" },
      {:httpoison, "~> 1.7"},
      {:elixir_xml_to_map, "~> 2.0"},
      {:elixir_map_to_xml, "~> 0.1.0"},
      {:jason, "~> 1.1"},
      {:confex, "~> 3.4"},
      {:ex_doc, "~> 0.20", only: :dev},
      {:mock, "~> 0.3.2", only: :test}
    ]
  end

  defp description do
    """
    Aliyun OSS API(阿里云对象存储 OSS API)
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ug0/aliyun_oss"},
      source_urL: "https://github.com/ug0/aliyun_oss",
      homapage_url: "https://github.com/ug0/aliyun_oss"
    ]
  end

  defp docs do
    [
      main: "Aliyun.Oss",
      groups_for_modules: [
        "Bucket": [
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
          Aliyun.Oss.Bucket.CORS,
        ],
        "Object": [
          Aliyun.Oss.Object,
          Aliyun.Oss.Object.MultipartUpload,
          Aliyun.Oss.Object.ACL,
          Aliyun.Oss.Object.Symlink,
          Aliyun.Oss.Object.Tagging,
        ],
        "LiveChannel": [
          Aliyun.Oss.LiveChannel
        ],
        "HTTP Client": [
          Aliyun.Oss.Client,
          Aliyun.Oss.Client.Request,
          Aliyun.Oss.Client.Response,
          Aliyun.Oss.Client.Error
        ],
        "Configuration": [
          Aliyun.Oss.Config
        ]
      ]
    ]
  end
end
