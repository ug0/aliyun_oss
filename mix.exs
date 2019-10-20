defmodule AliyunOss.MixProject do
  use Mix.Project

  def project do
    [
      app: :aliyun_oss,
      version: "0.4.0",
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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mime, "~> 1.3"},
      {:aliyun_util, "~> 0.3.3" },
      {:httpoison, "~> 1.4"},
      {:elixir_xml_to_map, "~> 0.1"},
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
        # Aliyun.Oss,
        # Aliyun.Oss.Bucket,
        # Aliyun.Oss.Object,

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
