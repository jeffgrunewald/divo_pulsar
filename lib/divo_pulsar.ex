defmodule DivoPulsar do
  @moduledoc """
  Defines a pulsar broker in 'standalone' mode
  as a map compatible with divo for building a
  docker-compose file.
  """

  @behaviour Divo.Stack

  @doc """
  Implements the Divo Stack behaviour to take a
  keyword list of defined variables specific to
  the DivoPulsar stack and returns a map describing
  the service definition of Pulsar.

  ### Optional Configuration
  * `port`: The port on which the management API will be exposed to the host for making REST calls (for creating partitioned topics, posting schema, etc). The default port Pulsar uses for its REST API is 8080, which is commonly used by other services for web and REST accessibility and may be more likely to require an override if you are testing additional services alongside Pulsar simultaneously. This only effects the port exposed to the host; internally to the containerized service the API is listening on port 8080.

  * `ui_port`: The port on which the Pulsar dashboard will be exposed to the host. Configuring the UI port also enables the pulsar dashboard as part of the stack; this service is not enabled unless a port is specified. This only effects the port exposed to the host; internally to the containerized service the API is listening on port 80

  * `version`: The version of the Pulsar container image to create. Defaults to `latest`.
  """
  @impl Divo.Stack
  @spec gen_stack([tuple()]) :: map()
  def gen_stack(envars) do
    image_version = Keyword.get(envars, :version, "latest")
    api_port = Keyword.get(envars, :port, 8080)
    ui_port = Keyword.get(envars, :ui_port)

    pulsar_ports = ["6650:6650", exposed_ports(api_port, 8080)]

    pulsar_service = %{
      pulsar: %{
        image: "apachepulsar/pulsar:#{image_version}",
        ports: pulsar_ports,
        command: ["bin/pulsar", "standalone"],
        healthcheck: %{
          test: [
            "CMD-SHELL",
            "curl -I http://localhost:8080/admin/v2/namespaces/public/default | grep '200' || exit 1"
          ],
          interval: "5s",
          timeout: "10s",
          retries: 3
        }
      }
    }

    case ui_port == nil do
      true ->
        pulsar_service

      false ->
        dashboard_port = [exposed_ports(ui_port, 80)]

        Map.merge(pulsar_service, %{
          dashboard: %{
            image: "apachepulsar/pulsar-dashboard:latest",
            depends_on: ["pulsar"],
            ports: dashboard_port,
            environment: ["SERVICE_URL=http://pulsar:8080"]
          }
        })
    end
  end

  defp exposed_ports(external_port, internal_port) do
    to_string(external_port) <> ":" <> to_string(internal_port)
  end
end
