defmodule TwitterApi.Tweets.Replies do
  @moduledoc """
    Replies context
  """
  import Ecto.Query, warn: false

  alias TwitterApi.{Repo, Tweets}
  alias TwitterApi.Tweets.Tweet

  @doc """
    Create reply
  """
  @spec put_reply_to_tweet(non_neg_integer(), non_neg_integer()) :: {:ok, Reply.t()} | {:error, Ecto.Changeset.t()}
  def put_reply_to_tweet(tweet_id, reply_to_tweet) do
    tweet = Tweets.get_tweet!(tweet_id)
    %Tweet{reply: reply} = tweet

    changeset =
      tweet
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_embed(:reply, [%{reply_to_tweet: reply_to_tweet}] ++ reply)

    Repo.update(changeset)
  end
end