defmodule TwitterApiWeb.UserControllerTest do
  @moduledoc """
    Tests for user controller
  """
  use TwitterApiWeb.ConnCase, async: false

  alias TwitterApi.Accounts.User
  alias TwitterApiWeb.Support.Utils
  alias TwitterApiWeb.Support.User, as: UserHelper

  defp create_user(_) do
    email = Utils.random_email()
    user = UserHelper.user_fixture(%{email: email})

    {:ok, user: user}
  end

  defp login(%{conn: conn, user: user}) do
    {:ok, token, _claims} = TwitterApiWeb.Auth.Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "Subscriptions" do
    setup [:create_user, :login]

    test "", %{conn: conn, user: user} do
      subscriber = UserHelper.user_fixture()
      %User{
        username: username,
        email: email,
        second_name: second_name,
        first_name: first_name,
        middle_name: middle_name
      } = user

      response =
        conn
        |> post(Routes.user_path(conn, :subscribe, %{id: subscriber.id}))
        |> json_response(200)

      assert response == %{
        "user" => %{
          "username" => username,
          "user_ids" => [subscriber.id],
          "email" => email,
          "second_name" => second_name,
          "first_name" => first_name,
          "middle_name" => middle_name
        }
      }
    end
  end

end