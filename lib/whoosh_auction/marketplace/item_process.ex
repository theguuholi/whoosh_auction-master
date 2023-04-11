defmodule WhooshAuction.Marketplace.ItemProcess do
  @moduledoc """
  This GenServer is used to encapsulate the state of
  an auction item.
  """

  use GenServer, restart: :transient

  require Logger

  alias WhooshAuction.Marketplace.{
    Item,
    ItemRegistry
  }

  # +------------------------------------------------------------------+
  # |               GenServer Public API Functions                     |
  # +------------------------------------------------------------------+

  @doc """
  This function is used to start the GenServer.
  """
  def start_link(%Item{id: item_id} = item) do
    GenServer.start_link(__MODULE__, item, name: {:via, Registry, {ItemRegistry, item_id}})
  end

  # +------------------------------------------------------------------+
  # |                 GenServer Callback Functions                     |
  # +------------------------------------------------------------------+

  @impl true
  def init(%Item{} = item) do
    {:ok, item}
  end

  @impl true
  def handle_call(:get_item_details, _from, state) do
    {:reply, state, state}
  end
end
