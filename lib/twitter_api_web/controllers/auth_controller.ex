defmodule TwitterApiWeb.AuthController do
  use TwitterApiWeb, :controller

  alias TwitterApiWeb.Auth
  alias TwitterApiWeb.Auth.Guardian
  alias TwitterApi.Accounts.User

  require Logger

  def login(conn, %{"user" => %{"email" => "", "password" => ""}}), do: empty_fields(conn)

  def login(conn, %{"user" => %{"password" => ""}}), do: empty_fields(conn)

  def login(conn, %{"user" => %{"email" => ""}}), do: empty_fields(conn)

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Auth.login(email, password) do
      {:ok, %User{id: user_id} = user} ->
        Logger.info "User(id# #{inspect user_id}) logged in successfully"

        conn
        |> Guardian.Plug.sign_in(user, %{}, ttl: {30, :days})
        |> render("ok.json")

      {:error, error} ->
        Logger.error "Auth error #{inspect error}"

        render(conn, "unauthorized.json")
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> render("ok.json")
  end

  defp empty_fields(conn) do
    Logger.error "Auth error. Empty fields"

    render(conn, "unauthorized.json")
  end
end