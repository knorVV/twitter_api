defmodule TwitterApiWeb.TweetsControllerTest do
  @moduledoc """
    Tests for tweets controller
  """
  use TwitterApiWeb.ConnCase, async: false

  alias TwitterApiWeb.Support.Utils
  alias TwitterApiWeb.Support.User, as: UserHelper
  alias TwitterApiWeb.Support.Tweet, as: TweetHelper

  defp create_user(_) do
    email = Utils.random_email()
    user = UserHelper.user_fixture(%{email: email})

    {:ok, user: user}
  end

  defp create_tweet(%{user: user}) do
    user_id = user.id
    tweet = TweetHelper.tweet_fixture(%{user_id: user_id})

    {:ok, tweet: tweet}
  end

  defp login(%{conn: conn, user: user}) do
    {:ok, token, _claims} = TwitterApiWeb.Auth.Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "Create tweets" do
    setup [:create_user, :login]

    test "create/2", %{conn: conn} do
      response =
        conn
        |> post(Routes.tweets_path(conn, :create, %{tweet_text: "some_text"}))
        |> json_response(200)

      assert response == %{
        "tweet" => %{
          "tweet_text" => "some_text",
          "likes" => 0,
          "reply" => []
        }
      }
    end
  end

  describe "Tweets" do
    setup [:create_user, :login, :create_tweet]
    
    test "Get tweets. index/2", %{conn: conn, user: user} do
      response =
        conn
        |> get(Routes.tweets_path(conn, :index, %{id: user.id}))
        |> json_response(200)

      assert response == %{
        "tweets" => [
          %{
            "likes" => 0,
            "reply" => [],
            "tweet_text" => "some_text"
          }
        ]
      }
    end

    test "update tweet. update/2", %{conn: conn, tweet: tweet} do
      response =
        conn
        |> put(Routes.tweets_path(conn, :update, tweet, %{tweet_text: "some_update_text"}))
        |> json_response(200)

      assert response == %{
        "tweet" => %{
          "tweet_text" => "some_update_text",
          "likes" => 0,
          "reply" => []
        }
      }
    end

    test "update tweet with invalid attrs. update/2", %{conn: conn, tweet: tweet} do
      response =
        conn
        |> put(Routes.tweets_path(conn, :update, tweet, %{tweet_text: ""}))
        |> json_response(200)

      assert response == %{"error" => "error"}
    end

    test "delete tweet. update/2", %{conn: conn, tweet: tweet} do
      response =
        conn
        |> delete(Routes.tweets_path(conn, :delete, tweet))
        |> json_response(200)

      assert response == %{"status" => "ok"}
    end
  end

  describe "unauthorization actions" do
    setup [:create_user, :create_tweet]

    test "without authorization. create/2", %{conn: conn} do
      response =
        conn
        |> post(Routes.tweets_path(conn, :create, %{tweet_text: "some_text"}))
        |> json_response(200)

      assert response == %{"status" => "unauthorized"}
    end

    test "update tweet without authorization. update/2", %{conn: conn, tweet: tweet} do
      response =
        conn
        |> put(Routes.tweets_path(conn, :update, tweet, %{tweet_text: "some_update_text"}))
        |> json_response(200)

      assert response == %{"status" => "unauthorized"}
    end
    
    test "delete tweet without authorization. update/2", %{conn: conn, tweet: tweet} do
      response =
        conn
        |> delete(Routes.tweets_path(conn, :delete, tweet))
        |> json_response(200)

      assert response == %{"status" => "unauthorized"}
    end
  end
end