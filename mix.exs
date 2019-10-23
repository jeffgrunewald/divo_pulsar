defmodule DivoPulsar.MixProject do
  use Mix.Project

  def project() do
    [
      app: :divo_pulsar,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      description: description(),
      source_url: "https://github.com/jeffgrunewald/divo_pulsar"
    ]
  end

  def application() do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps() do
    [
      {:credo, "~> 1.1", only: :dev, runtime: false},
      {:divo, "~> 1.1.0"},
      {:ex_doc, "~> 0.19", only: :dev}
    ]
  end

  defp description() do
    "A pre-configured pulsar docker-compose stack definition for
    integration testing with the divo library."
  end

  defp package() do
    [
      maintainers: ["jeffgrunewald"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/jeffgrunewald/divo_pulsar"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      source_url: "https://github.com/jeffgrunewald/divo_pulsar",
      extras: [
        "README.md"
      ]
    ]
  end
end
