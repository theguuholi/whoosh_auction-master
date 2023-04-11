defmodule WhooshAuction.Marketplace do
  @moduledoc """
  This module acts as the Phoenix context to interact with market place items.
  """

  alias WhooshAuction.Marketplace.ItemDynamicSupervisor

  require Logger

  @doc """
  This function returns a list of all of the items currently in the application.
  """
  def list_items do
    ItemDynamicSupervisor.all_item_pids()
    |> Enum.map(fn pid ->
      :sys.get_state(pid)
    end)
  end

  @doc """
  This function will fetch the details from and auction item process.
  """
  def get_item(item_id) do
    try do
      GenServer.call({:via, ItemRegistry, item_id}, :get_item_details)
    catch
      :exit, reason ->
        Logger.info("Failed to call :get_item_details because: #{inspect(reason)}")
        {:error, :not_found}
    end
  end
end
