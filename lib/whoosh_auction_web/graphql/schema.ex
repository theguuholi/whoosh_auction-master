defmodule WhooshAuctionWeb.GraphQL.Schema do
  @moduledoc """
  """

  use Absinthe.Schema

  alias WhooshAuctionWeb.GraphQL.ItemResolver
  alias WhooshAuctionWeb.GraphQL.ItemType

  import_types ItemType

  query do
    @desc "Get all items"
    field :items, list_of(:item) do
      resolve &ItemResolver.list_items/3
    end

    @desc "Get all items"
    field :get_item, :item do
      arg :id, non_null(:id)
      resolve &ItemResolver.get_item/3
    end
  end
end
