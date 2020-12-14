defmodule TwitterApiWeb.Auth.CurrentUser do
  @moduledoc """
    Модуль для получения данных текущего пользователя
  """

  @doc """
    Для получения текущего пользователя.
  """
  def get_curent_user(conn), do: Guardian.Plug.current_resource(conn)
end