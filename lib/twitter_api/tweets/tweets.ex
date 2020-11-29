defmodule TwitterApi.Tweets do
  @moduledoc """
  The Tweets context.
  """

  import Ecto.Query, warn: false
  alias TwitterApi.Repo

  alias TwitterApi.Accounts.User
  alias TwitterApi.Tweets.Tweet
  alias TwitterApi.Accounts

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
  @spec list_tweets :: [Tweet.t(), ...]
  def list_tweets do
    Repo.all(Tweet)
  end

  @doc """
    Retur all user tweets by user id
  """
  @spec list_tweets_by_user_id(non_neg_integer()) :: [Tweet.t(), ...]
  def list_tweets_by_user_id(user_id) do
    Tweet
    |> where([t], t.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single tweet.

  Raises `Ecto.NoResultsError` if the Tweet does not exist.

  ## Examples

      iex> get_tweet!(123)
      %Tweet{}

      iex> get_tweet!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_tweet!(non_neg_integer()) :: Twwet.t() | Ecto.NoResultsError.t()
  def get_tweet!(id), do: Repo.get!(Tweet, id)

  @doc """
    Get a liked tweets
  """
  @spec get_liked_tweets_by_user(non_neg_integer()) :: [Tweet.t(), ...] | []
  def get_liked_tweets_by_user(user_id) do
    Tweet
    |> where([t], t.user_id == ^user_id)
    |> where([t], t.likes > 0) # Лайков больше 0
    |> order_by([t], desc: t.likes)
    |> Repo.all()
  end

  @doc """
    Get subscribers tweets
  """
  @spec get_subscribers_tweets(non_neg_integer()) :: [Tweet.t(), ...] | []
  def get_subscribers_tweets(user_id) do
    %User{user_ids: user_ids} = Accounts.get_bare_user!(user_id) # Получаем обновленные параметры пользователя

    Tweet
    |> where([t], t.user_id in ^user_ids)
    |> order_by([t], desc: t.inserted_at)
    |> Repo.all()
  end

  @doc """
  Creates a tweet.

  ## Examples

      iex> create_tweet(%{field: value})
      {:ok, %Tweet{}}

      iex> create_tweet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_tweet(map()) :: {:ok, Tweet.t()} | {:error, Ecto.Changeset.t()}
  def create_tweet(attrs \\ %{}) do
    %Tweet{}
    |> Tweet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tweet.

  ## Examples

      iex> update_tweet(tweet, %{field: new_value})
      {:ok, %Tweet{}}

      iex> update_tweet(tweet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_tweet(Tweet.t(), map()) :: {:ok, Tweet.t()} | {:error, Ecto.Changeset.t()}
  def update_tweet(%Tweet{} = tweet, attrs) do
    tweet
    |> Tweet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tweet.

  ## Examples

      iex> delete_tweet(tweet)
      {:ok, %Tweet{}}

      iex> delete_tweet(tweet)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_tweet(Tweet.t()) :: {:ok, Tweet.t()} | {:error, Ecto.Changeset.t()}
  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tweet changes.

  ## Examples

      iex> change_tweet(tweet)
      %Ecto.Changeset{data: %Tweet{}}

  """
  @spec update_tweet(Tweet.t(), map()) :: Ecto.Changeset.t()
  def change_tweet(%Tweet{} = tweet, attrs \\ %{}) do
    Tweet.changeset(tweet, attrs)
  end
end
