defmodule WhooshAuction.Marketplace.ItemHydrator do
  @moduledoc """
  This GenServer is responsible for blocking the supervision tree until
  the item registry and dynamic supervisor have been hydrated with the
  application state.
  """

  use GenServer

  require Logger

  alias WhooshAuction.Marketplace.{
    Item,
    ItemDynamicSupervisor
  }

  @doc """
  Start the item hydrator GenServer
  """
  def start_link(initial_items) do
    GenServer.start_link(__MODULE__, initial_items, name: __MODULE__)
  end

  @impl true
  def init(initial_items) do
    initial_items
    |> Enum.each(fn %Item{} = item ->
      {:ok, _pid} = ItemDynamicSupervisor.add_item_to_supervisor(item)
      Logger.debug("Added item with ID #{item.id} to auction registry")
    end)

    :ignore
  end
end
