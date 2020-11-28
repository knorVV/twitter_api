defmodule TwitterApiWeb.Support.User do
  alias alias TwitterApi.Accounts

  def user_fixture(attrs \\ %{}) do
    user_fixture(user_valid_params(), attrs)
  end

  def user_fixture(base_attrs, attrs) do
    {:ok, user} =
      base_attrs
      |> Map.merge(attrs)
      |> Accounts.create_user()

    user
  end

  defp user_valid_params, do: %{
    email: "email@email.em",
    password: "password",
    username: "username"
  }
end