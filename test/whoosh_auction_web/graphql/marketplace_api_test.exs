defmodule WhooshAuctionWeb.GraphQL.MarketplaceApiTest do
  # Tests cannot run ASYNC since the marketplace supervisor is referenced by name and is singleton
  use WhooshAuctionWeb.ConnCase, async: false

  alias WhooshAuction.Marketplace.Item
  alias WhooshAuction.Marketplace.ItemSupervisor

  describe "The items query" do
    @list_all_items_query """
    query {
      items {
        id
        name
        price
      }
    }
    """

    test "should return an empty list of items if none exist", %{conn: conn} do
      initial_items = []
      start_supervised({ItemSupervisor, initial_items})

      result = gql_api(conn, @list_all_items_query)
      assert %{"data" => %{"items" => []}} = result
    end

    test "should return all of the items in the application when there are items present", %{conn: conn} do
      initial_items = [
        Item.new("1", "Item 1", "Some cool thing", "$1"),
        Item.new("2", "Item 2", "Another cool thing", "$2")
      ]

      start_supervised({ItemSupervisor, initial_items})

      # We are not guaranteed order so we need to massage the data a bit
      %{"data" => %{"items" => fetched_items}} = gql_api(conn, @list_all_items_query)

      assert Enum.sort(fetched_items) == [
               %{"id" => "1", "name" => "Item 1", "price" => "$1"},
               %{"id" => "2", "name" => "Item 2", "price" => "$2"}
             ]
    end
  end

  defp gql_api(conn, query, variables \\ %{}) do
    conn
    |> post("/api", %{variables: variables, query: query})
    |> Map.get(:resp_body)
    |> Jason.decode!()
  end
end
