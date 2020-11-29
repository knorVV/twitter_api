defmodule TwitterApiWeb.UserController do
  use TwitterApiWeb, :controller

  import TwitterApiWeb.Auth.CurrentUser

  alias TwitterApi.Accounts

  require Logger

  def subscribe(conn, %{"id" => subscribed_id}) do
    current_user = get_curent_user(conn)

    case Accounts.add_subscription(current_user, subscribed_id) do
      {:ok, user} ->
        Logger.info "Subscription succesful added. User id# #{inspect current_user.id}, subscribed id# #{inspect subscribed_id}."
        render(conn, "ok.json", %{user: user})

      {:error, reason} ->
        Logger.error "Error during adding subscription. Error: #{reason}"
        render(conn, "error.json")
    end
  end
end