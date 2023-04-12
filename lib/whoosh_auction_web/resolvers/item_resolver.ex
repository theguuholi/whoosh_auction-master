defmodule WhooshAuctionWeb.GraphQL.ItemResolver do
  @moduledoc """
  This module contains all of the resolver functions for
  item related queries and mutations.
  """

  alias WhooshAuction.Marketplace

  def list_items(_parent, _args, _resolution) do
    {:ok, Marketplace.list_items()}
  end

  def get_item(_parent, %{id: id}, _resolution) do
    result = Marketplace.get_item(id)

    if is_map(result) do
      {:ok, result}
    else
      result
    end
  end

  def create_item(_parent, %{item: item}, _resolution) do
    Marketplace.create_item(item)
    {:ok, "Item created"}
  end
end
