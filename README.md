# DivoPulsar

A library implementing the Divo Stack behaviour, providing a pre-configured Pulsar broker via docker-compose for integration testing Elixir apps. The broker runs in standalone mode.

Requires inclusion of the Divo library in your mix project.

## Installation

The package can be installed by adding `divo` and `divo_pulsar` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:divo, "~> 1.1.0"},
    {:divo_pulsar, "~> 0.1.0"}
  ]
end
```

## Use
In your Mix configuration file (i.e. config/integration.exs), include the following:

```elixir
config :myapp,
  divo: [
    {DivoPulsar, [port: 8080]}
  ]
```

In your integration test, specify that you want to use Divo:
```elixir
use Divo, services: [:pulsar]
```

The resulting stack will create a single Pulsar broker in standalone mode exposing the standard port 6650 for broker communication and port 8080 for the api.

## Configuration
You may omit the configuration arguments to DivoPulsar and still have a working stack. The unmodified configuration will create the broker only and only expose the producer/consumer port.

* `port`: The port on which the management API will be exposed to the host for making REST calls (for creating partitioned topics, posting schema, etc). The default port Pulsar uses for its REST API is 8080, which is commonly used by other services for web and REST accessibility and may be more likely to require an override if you are testing additional services alongside Pulsar simultaneously. This only effects the port exposed to the host; internally to the containerized service the API is listening on port 8080.

* `ui_port`: The port on which the Pulsar dashboard will be exposed to the host. Configuring the UI port also enables the pulsar dashboard as part of the stack; this service is not enabled unless a port is specified. This only effects the port exposed to the host; internally to the containerized service the API is listening on port 80

* `version`: The version of the Pulsar container image to create. Defaults to `latest`.

See [Divo GitHub](https://github.com/smartcitiesdata/divo) or [Divo Hex Documentation](https://hexdocs.pm/divo) for more instructions on using and configuring the Divo library.
See [Pulsar Dockerhub](https://hub.docker.com/r/apachepulsar/pulsar) for further documentation
on using and configuring the features of the container image itself.
See [Pulsar source](https://pulsar.apache.org/) for the full codebase behind Pulsar
