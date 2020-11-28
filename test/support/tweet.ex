defmodule TwitterApiWeb.Support.Tweet do

  alias TwitterApi.Tweets
  alias TwitterApi.Accounts.User
  alias TwitterApiWeb.Support.User, as: UserHelper

  def tweet_fixture(attrs \\ %{}) do
    user_id = simple_user()
    attrs = Map.put_new(attrs, :user_id, user_id)

    tweet_fixture(tweet_valid_attrs(),  attrs)
  end

  def tweet_fixture(base_attrs, attrs) do
    {:ok, tweet} =
      base_attrs
      |> Map.merge(attrs)
      |> Tweets.create_tweet()

    tweet
  end

  def simple_user() do
    %User{id: user_id} = UserHelper.user_fixture()

    user_id
  end

  defp tweet_valid_attrs, do: %{tweet_text: "some_text"}
end