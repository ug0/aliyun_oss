defmodule AliyunOss.MixProject do
  use Mix.Project

  def project do
    [
      app: :aliyun_oss,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
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
end
