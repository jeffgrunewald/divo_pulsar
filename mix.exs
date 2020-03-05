defmodule DivoPulsar.MixProject do
  use Mix.Project

  @github "https://github.com/jeffgrunewald/divo_pulsar"

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
      source_url: @github,
      homepage_url: @github
    ]
  end

  def application() do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps() do
    [
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
      links: %{"GitHub" => @github}
    ]
  end

  defp docs() do
    [
      source_url: @github,
      extras: ["README.md"],
      source_url_pattern: "#{@github}/blob/master/%{path}#L%{line}"
    ]
  end
end
