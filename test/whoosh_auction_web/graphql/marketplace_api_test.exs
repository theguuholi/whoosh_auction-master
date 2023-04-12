defmodule WhooshAuctionWeb.GraphQL.MarketplaceApiTest do
  # Tests cannot run ASYNC since the marketplace supervisor is referenced by name and is singleton
  use WhooshAuctionWeb.ConnCase, async: false

  alias WhooshAuction.Marketplace.Item
  alias WhooshAuction.Marketplace.ItemSupervisor

  @items_list [
    Item.new("1", "Item 1", "Some cool thing", "$1"),
    Item.new("2", "Item 2", "Another cool thing", "$2")
  ]

  @get_item_query """
  query getItem($id: ID!) {
    get_item(id: $id) {
      id
      name
      price
    }
  }
  """

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

  describe "the specific item" do
    test "given an item ID, when call the query, should return a specific item", %{conn: conn} do
      start_supervised({ItemSupervisor, @items_list})

      result = gql_api(conn, @get_item_query, %{id: "2"})

      assert %{
               "data" => %{
                 "get_item" => %{"id" => "2", "name" => "Item 2", "price" => "$2"}
               }
             } = result
    end

    test "given an item ID that does not exist, when call the query, should return error", %{conn: conn} do
      start_supervised({ItemSupervisor, @items_list})

      result = gql_api(conn, @get_item_query, %{id: "4444"})

      assert %{
               "data" => %{"get_item" => nil},
               "errors" => [
                 %{"locations" => [%{"column" => 3, "line" => 2}], "message" => "not_found", "path" => ["get_item"]}
               ]
             } = result
    end
  end

  describe "add a new item to the auction marketplace" do
    test "given an item, when call the mutation, should create an item", %{conn: conn} do
      start_supervised({ItemSupervisor, []})

      %{"data" => %{"items" => fetched_items}} = gql_api(conn, @list_all_items_query)

      assert Enum.sort(fetched_items) == []

      query = """
        mutation {
          createItem(item:
            {
              id: "555",
              name: "Test",
              description: "Test Description",
              price: "123"
            }
          )
        }
      """

      result = gql_api(conn, query, %{})

      assert %{"data" => %{"createItem" => "Item created"}} = result

      %{"data" => %{"items" => fetched_items}} = gql_api(conn, @list_all_items_query)

      assert Enum.sort(fetched_items) == [%{"id" => "555", "name" => "Test", "price" => "123"}]
    end

    test "given an item that already, when call the mutation, should not create an item", %{conn: conn} do
      start_supervised({ItemSupervisor, []})

      %{"data" => %{"items" => fetched_items}} = gql_api(conn, @list_all_items_query)

      assert Enum.sort(fetched_items) == []

      query = """
        mutation {
          createItem(item:
            {
              id: "555",
              name: "Test",
              description: "Test Description",
              price: "123"
            }
          )
        }
      """

      gql_api(conn, query, %{})
      gql_api(conn, query, %{})

      %{"data" => %{"items" => fetched_items}} = gql_api(conn, @list_all_items_query)

      assert Enum.sort(fetched_items) == [%{"id" => "555", "name" => "Test", "price" => "123"}]
    end
  end

  defp gql_api(conn, query, variables \\ %{}) do
    conn
    |> post("/api", %{variables: variables, query: query})
    |> Map.get(:resp_body)
    |> Jason.decode!()
  end
end
