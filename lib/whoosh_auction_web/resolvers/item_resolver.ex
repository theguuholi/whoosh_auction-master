defmodule WhooshAuctionWeb.GraphQL.ItemResolver do
  @moduledoc """
  This module contains all of the resolver functions for
  item related queries and mutations.
  """

  alias WhooshAuction.Marketplace

  def list_items(_parent, _args, _resolution) do
    {:ok, Marketplace.list_items()}
  end
end
