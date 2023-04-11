defmodule WhooshAuction.Marketplace.Item do
  @moduledoc """
  This module is used to house data related to a particular
  item. It's primarily used by the ItemProcess GenServer to
  initialize its state.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          description: String.t(),
          price: String.t()
        }

  @enforce_keys [:id, :name, :description, :price]
  defstruct [:id, :name, :description, :price]

  @doc """
  Create a new instance of the struct
  """
  def new(id, name, description, price) do
    %__MODULE__{
      id: id,
      name: name,
      description: description,
      price: price
    }
  end
end
