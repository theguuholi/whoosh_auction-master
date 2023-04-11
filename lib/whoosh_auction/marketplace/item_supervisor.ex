defmodule WhooshAuction.Marketplace.ItemSupervisor do
  @moduledoc """
  This supervisor starts all of the necessary components of the item auction
  supervision tree (the registry, dynamic supervisor, and the initial state
  hydrator).
  """

  use Supervisor

  alias WhooshAuction.Marketplace.{
    ItemDynamicSupervisor,
    ItemHydrator,
    ItemRegistry
  }

  def start_link(init_args) do
    Supervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  @impl true
  def init(init_args) do
    children = [
      ItemRegistry.child_spec(),
      ItemDynamicSupervisor,
      {ItemHydrator, init_args}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
