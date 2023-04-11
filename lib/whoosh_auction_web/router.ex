defmodule WhooshAuctionWeb.Router do
  use WhooshAuctionWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: WhooshAuctionWeb.GraphQL.Schema, interface: :playground
    forward "/", Absinthe.Plug, schema: WhooshAuctionWeb.GraphQL.Schema
  end

  # Enables LiveDashboard only for development
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: WhooshAuctionWeb.Telemetry
    end
  end
end
