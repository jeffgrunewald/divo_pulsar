defmodule DivoPulsarTest do
  use ExUnit.Case

  describe "produces a pulsar stack map" do
    test "with no specified environment variables" do
      expected = %{
        pulsar: %{
          image: "apachepulsar/pulsar:latest",
          ports: ["6650:6650", "8080:8080"],
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

      actual = DivoPulsar.gen_stack([])

      assert actual == expected
    end

    test "produces a pulsar stack map with supplied environment config" do
      expected = %{
        pulsar: %{
          image: "apachepulsar/pulsar:v2",
          ports: ["6650:6650", "8079:8080"],
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
        },
        dashboard: %{
          image: "apachepulsar/pulsar-dashboard:latest",
          depends_on: ["pulsar"],
          ports: ["80:80"],
          environment: ["SERVICE_URL=http://pulsar:8080"]
        }
      }

      actual = DivoPulsar.gen_stack(port: 8079, ui_port: 80, version: "v2")

      assert actual == expected
    end
  end
end
