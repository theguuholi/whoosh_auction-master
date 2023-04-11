# WhooshAuction Interview Assignment

This interview assignment has a number of features that need to be implemented, but please make sure that you time-box
your work to no more than 3 hours. It is far more important to complete a few of the requirements but at a high level of
quality, than to try and complete all of the features and have them only half work (i.e quality over quantity).

## Background

In this hypothetical project, we are attempting to make a high performance auction marketplace for golf memorabilia.
Given that performance is a key requirement for the application, our architecture makes heavy use of Erlang's actor
model. Specifically, a GenServer is started under a dynamic supervisor for each item in the auction marketplace, and can
be retrieved via its ID in an Elixir registry (look at the `WhooshAuction.Marketplace` module to see how this is done).

Each item is a small struct (see module `WhooshAuction.Marketplace.Item`) that contains the ID, name, description, and
price of the particular auction item. Each GenServer that is started contains its specific `Item` struct as the state.
All of these item GenServers comprise our data layer and can be retrieved by the `WhooshAuction.Marketplace.get_item/1`
function .

Our frontend team requires a GraphQL API in order to present this data to the user, and so we lean on Absinthe in order
to interact with our auction items. Presently, there is only one query to fetch all of the items out of our data layer,
but we will definitely require some additional functionality so that our frontend team could move forward.

## Feature requirements

Please work on the features in the provided order, and be sure to include test cases for each feature.  We are still in just the PoC phase
of the application, so no need to worry about authorization or authentication.

The frontend team requires the following:

1. A GraphQL query to fetch one specific item

2. A mutation to add a new item to the auction marketplace

3. A mutation to update an item in the auction marketplace

4. A mutation to delete an item from the auction marketplace

5. A new supervision tree and data layer (similarly to `WhooshAuction.Marketplace.ItemSupervisor`) but for users needs
   to be created. The `User` struct only needs to have the following fields: `[:id, :first_name, :last_name]`. In
   addition, the `WhooshAuction.Marketplace.Item` struct needs to be updated in order to reference a user via a new
   struct key `:user_id`.

6. The GraphQL API needs to be updated so that users can be queried in relation to items. Something like follows should
   be a valid GraphQL query afer you are done with this feature:

```graphql
query {
  items {
    id
    name
    price
    user {
      id
      first_name
      last_name
    }
  }
}
```

## Getting started

When you're ready to get started, you can fork this repo and then create a Pull Request on your forked repo (not back to the original repo).  When you're ready to share it with us, please add the following users to your repo and let us know:
```
cspeper
akoutmos
```

After you have the code on your workstation, you can get started by doing the following:

```terminal
# Run this first to fetch the application dependencies
$ mix deps.get

# To start the Phoenix server with an active IEx session
$ iex -S mix phx.server

# To run the test suite
$ mix test
```

## Discussion Questions

1. What possible trade-offs do you see in how the data layer is designed?
2. Given the current architecture, let's pretend that our item GenServers start becoming a bottleneck. What kinds of
   tools would you reach for in order to increase the performance of the application?
3. If given the opportunity, how would you design the backend differently?
