defmodule WhooshAuctionWeb.GraphQL.ItemType do
  use Absinthe.Schema.Notation

  object :item do
    field :id, :string
    field :name, :string
    field :description, :string
    field :price, :string
  end

  input_object :item_input do
    field :id, :string
    field :name, :string
    field :description, :string
    field :price, :string
  end
end
