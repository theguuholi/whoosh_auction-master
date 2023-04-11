defmodule WhooshAuction.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias WhooshAuction.Marketplace.Item

  @impl true
  def start(_type, _args) do
    children =
      List.flatten([
        # Start the Telemetry supervisor
        WhooshAuctionWeb.Telemetry,

        # Start the marketplace supervisor
        maybe_start_item_supervisor(),

        # Start the PubSub system
        {Phoenix.PubSub, name: WhooshAuction.PubSub},

        # Start the Endpoint (http/https)
        WhooshAuctionWeb.Endpoint
      ])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WhooshAuction.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WhooshAuctionWeb.Endpoint.config_change(changed, removed)

    :ok
  end

  defp maybe_start_item_supervisor do
    # Only start the supervisor if the environment is not test.
    # It is assumed that tests will start up the supervisor
    # prior to each test case to seed necessary data

    if Mix.env() != :test do
      {WhooshAuction.Marketplace.ItemSupervisor, initial_dummy_items()}
    else
      []
    end
  end

  defp initial_dummy_items do
    [
      {"Tiger Woods' nine iron", "This item is super rare and will cost you an arm and a leg.", "$99,999"},
      {"Tiger Woods' hat", "This is the hat Tiger wore when he won the PGA Championship in 2008", "$1,000"},
      {"Rory McIlroy hat", "This is the hat that Rory wore when he won the PGA Championship in 2021", "$1,000"}
    ]
    |> Enum.with_index(1)
    |> Enum.map(fn {{name, description, price}, index} ->
      Item.new(Integer.to_string(index), name, description, price)
    end)
  end
end
