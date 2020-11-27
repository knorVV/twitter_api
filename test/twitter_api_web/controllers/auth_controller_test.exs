defmodule TwitterApiWeb.AuthControllerTest do
  use TwitterApiWeb.ConnCase, async: false

  alias TwitterApi.Accounts
  
  @user_valid_params %{email: "email@email.em", password: "password", username: "username"}

  defp create_user(_) do
    {:ok, user} = Accounts.create_user(@user_valid_params)

    {:ok, user: user}
  end

  defp login(conn) do
    post(conn, Routes.auth_path(conn, :login, %{user: %{email: "email@email.em", password: "password"}}))
  end

  describe "Authorization" do
    setup [:create_user]

    test "login/2", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login, %{user: %{email: "email@email.em", password: "password"}}))

      response = json_response(conn, 200)

      assert response == %{"status" => "ok"}
    end

    test "with incorrect data. login/2", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login, %{user: %{email: "email@email.ef", password: "passssss"}}))

      response = json_response(conn, 200)

      assert response == %{"status" => "unauthorized"}
    end

    test "with empty fields. login/2", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login, %{user: %{email: "", password: ""}}))

      response = json_response(conn, 200)

      assert response == %{"status" => "unauthorized"}
    end

    test "logout/2", %{conn: conn} do
      conn =
        conn
        |> login()
        |> delete(Routes.auth_path(conn, :logout))

      response = json_response(conn, 200)

      assert response == %{"status" => "ok"}
    end
  end
  
end