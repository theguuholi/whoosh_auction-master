defmodule WhooshAuction.Marketplace.ItemDynamicSupervisor do
  @moduledoc """
  This module is responsible for starting item GenServers and
  then supervising them while the user interacts with the bulk sync
  operations from the frontend.
  """

  use DynamicSupervisor

  alias WhooshAuction.Marketplace.{Item, ItemProcess}

  @doc """
  This function is used to start the DynamicSupervisor in the supervision tree
  """
  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Start a new item process and adds it to the DynamicSupervisor.
  """
  def add_item_to_supervisor(%Item{} = item) do
    child_spec = %{
      id: ItemProcess,
      start: {ItemProcess, :start_link, [item]},
      restart: :transient
    }

    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  Gets all of the PIDs upnder this DynamicSupervisor.
  """
  def all_item_pids do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Enum.reduce([], fn {_, item_pid, _, _}, acc ->
      [item_pid | acc]
    end)
  end
end
