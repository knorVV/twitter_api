defmodule TwitterApi.AccountsTest do
  @moduledoc """
    Tests for acconts context
  """

  use TwitterApi.DataCase

  alias TwitterApi.Accounts
  alias TwitterApiWeb.Support.User, as: UserHelper

  describe "users" do
    alias TwitterApi.Accounts.User

    @valid_attrs %{email: "email@email.em", password: "password", username: "username", second_name: "second_name", first_name: "first_name"}
    @update_attrs %{email: "email@email.em", password: "password1", username: "username1", second_name: "second_name1", first_name: "first_name1"}
    @invalid_attrs %{email: "", password: "1"}

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "email@email.em"
      assert user.username == "username"
      assert user.second_name == "second_name"
      assert user.first_name == "first_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = UserHelper.user_fixture(@valid_attrs)
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)

      assert user.username == "username1"
      assert user.second_name == "second_name1"
      assert user.first_name == "first_name1"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = UserHelper.user_fixture(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    end

    test "delete_user/1 deletes the user" do
      user = UserHelper.user_fixture(@valid_attrs)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_bare_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = UserHelper.user_fixture(@valid_attrs)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
