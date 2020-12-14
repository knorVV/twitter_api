defmodule TwitterApi.TweetsTest do
  @moduledoc """
    Tests for tweets context
  """
  use TwitterApi.DataCase

  alias TwitterApi.Tweets
  alias TwitterApiWeb.Support.Utils
  alias TwitterApiWeb.Support.User, as: UserHelper
  alias TwitterApiWeb.Support.Tweet, as: TweetHelper

  defp create_user(_) do
    email = Utils.random_email()
    user = UserHelper.user_fixture(%{email: email})

    {:ok, user: user}
  end

  describe "tweets" do
    setup :create_user
    alias TwitterApi.Tweets.Tweet

    @valid_attrs %{tweet_text: "some_text"}
    @update_attrs %{tweet_text: "some_update_text"}
    @invalid_attrs %{tweet_text: ""}

    test "list_tweets/0 returns all tweets" do
      tweet = TweetHelper.tweet_fixture()
      assert Tweets.list_tweets() == [tweet]
    end

    test "get_tweet!/1 returns the tweet with given id" do
      tweet = TweetHelper.tweet_fixture()
      assert Tweets.get_tweet!(tweet.id) == tweet
    end

    test "create_tweet/1 with valid data creates a tweet", %{user: user} do
      attrs = Map.put(@valid_attrs, :user_id, user.id)

      assert {:ok, %Tweet{} = tweet} = Tweets.create_tweet(attrs)
      assert tweet.tweet_text == "some_text"
      assert tweet.likes == 0
    end

    test "create_tweet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tweets.create_tweet(@invalid_attrs)
    end

    test "update_tweet/2 with valid data updates the tweet" do
      tweet = TweetHelper.tweet_fixture()
      assert {:ok, %Tweet{} = tweet} = Tweets.update_tweet(tweet, @update_attrs)
      assert tweet.tweet_text == "some_update_text"
      assert tweet.likes == 0
    end

    test "update_tweet/2 with invalid data returns error changeset" do
      tweet = TweetHelper.tweet_fixture()
      assert {:error, %Ecto.Changeset{}} = Tweets.update_tweet(tweet, @invalid_attrs)
      assert tweet == Tweets.get_tweet!(tweet.id)
    end

    test "delete_tweet/1 deletes the tweet" do
      tweet = TweetHelper.tweet_fixture()
      assert {:ok, %Tweet{}} = Tweets.delete_tweet(tweet)
      assert_raise Ecto.NoResultsError, fn -> Tweets.get_tweet!(tweet.id) end
    end

    test "change_tweet/1 returns a tweet changeset" do
      tweet = TweetHelper.tweet_fixture()
      assert %Ecto.Changeset{} = Tweets.change_tweet(tweet)
    end
  end
end
