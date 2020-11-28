defmodule TwitterApiWeb.Auth do
  @moduledoc """
    Модуль для проверки пароля пользователя
  """
  alias TwitterApi.Accounts
  alias TwitterApi.Accounts.User
  require Logger

  @spec login(String.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def login(email, password) do
    email
    |> Accounts.get_user_by_email()
    |> check_password(password)
  end

  defp check_password(nil, _), do: {:error, "Incorrect username or password"}
  defp check_password(user, password) do
    case Bcrypt.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
  end
end