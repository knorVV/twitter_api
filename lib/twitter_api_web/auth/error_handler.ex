defmodule TwitterApiWeb.Auth.ErrorHandler do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller, only: [put_view: 2, render: 2]

  alias TwitterApiWeb.AuthView

  require Logger

  def auth_error(conn, error_type, _opts) do
    Logger.info("Auth Error: #{inspect(error_type)}")

    conn
    |> put_view(AuthView)
    |> render("unauthorized.json")
    |> halt()
  end
end