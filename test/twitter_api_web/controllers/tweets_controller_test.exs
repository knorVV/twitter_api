defmodule TwitterApiWeb.TweetsControllerTest do
  @moduledoc """
    Tests for tweets controller
  """
  use TwitterApiWeb.ConnCase, async: false

  alias TwitterApi.Tweets
  alias TwitterApi.Accounts
  alias TwitterApi.Accounts.User
  alias TwitterApiWeb.Support.Utils
  alias TwitterApiWeb.Support.User, as: UserHelper
  alias TwitterApiWeb.Support.Tweet, as: TweetHelper

  defp create_user(_) do
    email = Utils.random_email()
    user = UserHelper.user_fixture(%{email: email})

    {:ok, user: user}
  end

  defp create_tweet(%{user: user}) do
    %User{id: user_id} = user
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

  defp create_tweets(user) do
    {:ok, user: first_subscription} = create_user(%{}) # Первый пользователь
    {:ok, user: seccond_subscription} = create_user(%{}) # Второй пользователь

    subscription_list = [first_subscription, seccond_subscription] # Список пользователей
    Enum.each(subscription_list, &Accounts.add_subscription(update_user(user.id), &1.id)) # Подписка на пользователей

    list_for_tweets = [ # Список из id пользователя(подписка) и текста твита
      {first_subscription.id, "some_text"},
      {seccond_subscription.id, "another_text"}
    ]

    Enum.each(list_for_tweets, fn({id, text}) ->
      TweetHelper.tweet_fixture(%{user_id: id, tweet_text: text})
      :timer.sleep(1000) # 1 секунда между твитами
    end) # Создание для каждого пользователя твита
  end

  defp update_user(id) do
    TwitterApi.Repo.get(User, id)
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
    
    test "get tweets. index/2", %{conn: conn, user: user} do
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

    test "get liked twieets. liked_tweets/2", %{conn: conn, user: user, tweet: first_tweet} do
      # К первому твиту добавляется 1 лайк
      Tweets.update_tweet(first_tweet, %{likes: 1})

      # Создается второй твит с 3мя лайками
      TweetHelper.tweet_fixture(%{user_id: user.id, likes: 3})

      response =
        conn
        |> get(Routes.tweets_path(conn, :liked_tweets))
        |> json_response(200)

      assert response == %{
          "tweets" => [
            %{"tweet_text" => "some_text", "likes" => 3, "reply" => []},
            %{"tweet_text" => "some_text", "likes" => 1, "reply" => []}
        ]
      }
    end

    test "get supscribers twieets. subscribers_tweets/2", %{conn: conn, user: user} do
      # Создаются твиты для привязанных пользователей
      create_tweets(user)

      response =
        conn
        |> get(Routes.tweets_path(conn, :subscribers_tweets))
        |> json_response(200)

      [last_tweet, first_tweet] = response["tweets"]

      assert last_tweet["tweet_text"] == "another_text"
      assert first_tweet["tweet_text"] == "some_text"
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

    test "update likes. likes_update/2", %{conn: conn, tweet: tweet} do
      {:ok, updated_tweet} = Tweets.update_tweet(tweet, %{likes: 1})

      response =
        conn
        |> assign(:authorized, true)
        |> put(Routes.tweets_path(conn, :likes_update, updated_tweet, %{likes: 1}))
        |> json_response(200)

      assert response == %{
        "tweet" => %{
          "tweet_text" => "some_text",
          "likes" => 2,
          "reply" => []
        }
      }
    end

    test "update tweet with invalid attrs. update/2", %{conn: conn, tweet: tweet} do
      response =
        conn
        |> put(Routes.tweets_path(conn, :update, tweet, %{tweet_text: ""}))
        |> json_response(200)

      assert response == %{"status" => "error"}
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