defmodule TwitterApiWeb.ReplyControllerTest do
  @moduledoc """
    Tests for reply controller
  """
  use TwitterApiWeb.ConnCase, async: false

  alias TwitterApiWeb.Support.Utils
  alias TwitterApiWeb.Support.User, as: UserHelper
  alias TwitterApiWeb.Support.Tweet, as: TweetHelper

  @reply %{reply_to_tweet: "some_text"}
  @next_reply %{reply_to_tweet: "next_reply_text"}

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

  describe "Create rely" do
    setup [:create_user, :create_tweet]

    test "first reply. create/2", %{conn: conn, tweet: tweet} do
      response =
        conn
        |> assign(:authorized, true)
        |> post(Routes.reply_path(conn, :create, tweet, @reply))
        |> json_response(200)

      assert response == %{"status" => "ok"}
    end

    test "next reply. create/2", %{conn: conn, tweet: tweet} do
      response =
        conn
        |> assign(:authorized, true)
        |> post(Routes.reply_path(conn, :create, tweet, @next_reply))
        |> json_response(200)

      assert response == %{"status" => "ok"}
    end
  end
end