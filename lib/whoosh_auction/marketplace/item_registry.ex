defmodule WhooshAuction.Marketplace.ItemRegistry do
  @moduledoc """
  This module is responsible for keeping track of all of the
  item auction processes that are currently running in the application
  instance. It will also function as the look up mechanism so that
  requests coming in related to an item can be routed to the
  correct GenServer.
  """

  @doc """
  This function returns the child spec for this module so that it
  can easily be added to the supervision tree.
  """
  def child_spec do
    Registry.child_spec(
      keys: :unique,
      name: __MODULE__,
      partitions: System.schedulers_online()
    )
  end

  @doc """
  This function looks up an item process by its ID so that the
  process can be then interacted with via its PID.
  """
  def lookup_item(item_id) do
    case Registry.lookup(__MODULE__, item_id) do
      [{item_pid, _}] ->
        {:ok, item_pid}

      [] ->
        {:error, :not_found}
    end
  end

  # The below functions are used under the hood when leveraging :via
  # to process PID lookup through a registry.

  @doc false
  def whereis_name(item_id) do
    case lookup_item(item_id) do
      {:ok, item_id} -> item_id
      _ -> :undefined
    end
  end
end
