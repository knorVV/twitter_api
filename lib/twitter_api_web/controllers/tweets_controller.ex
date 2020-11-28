defmodule TwitterApiWeb.TweetsController do
  use TwitterApiWeb, :controller

  alias TwitterApi.Tweets
  alias TwitterApi.Tweets.Tweet
  alias TwitterApi.Algo.LikesCalculatingAlgorithm, as: Likes

  require Logger

  def index(conn, _) do
    current_user = get_curent_user(conn)
    tweets = Tweets.list_tweets_by_user_id(current_user.id)

    Logger.info "Current user id# #{inspect current_user.id} tweets"
    render(conn, "ok.json", tweets: tweets)
  end

  def create(conn, params) do
    current_user = get_curent_user(conn)
    tweet =
      params
      |> Map.put("user_id", current_user.id)
      |> Tweets.create_tweet()

    case tweet do
      {:ok, tweet} ->
        Logger.info "Tweet succesful create by user id# #{inspect current_user.id}. Tweet id# #{inspect tweet.id}"
        render(conn, "ok.json", %{tweet: tweet})

      {:error, reason} ->
        Logger.error "Error during create tweet. Error: #{inspect reason}"
        render(conn, "error.json")
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = get_curent_user(conn)

    case Tweets.get_tweet!(id) do
      %Tweet{id: tweet_id} = tweet ->
        Logger.info "Show user(id# #{inspect current_user.id}) tweet. Tweet id# #{tweet_id}"
        render(conn, "ok.json", %{tweet: tweet})

      error ->
        Logger.error "Error during showing tweet. Error: #{inspect error}"
        render(conn, "error.json")
    end
  end

  def liked_tweets(conn, _) do
    current_user = get_curent_user(conn)

    case Tweets.get_liked_tweets_by_user(current_user.id) do
      [_ | _] = tweets ->
        Logger.info "Show user(id# #{inspect current_user.id}) liked tweets"
        render(conn, "ok.json", %{tweets: tweets})

      error ->
        Logger.error "Error during showing tweet. Error: #{inspect error}"
        render(conn, "error.json")
    end
  end

  def likes_update(conn, %{"id" => id, "likes" => likes}) do
    if conn.assigns[:authorized] do
      tweet = Tweets.get_tweet!(id)
      likes = Likes.calc_likes(tweet, likes)

      case Tweets.update_tweet(tweet, %{likes: likes}) do
        {:ok, %Tweet{id: tweet_id} = updated_tweet} ->
          Logger.info "Tweet(id# #{tweet_id}) likes succesful update."
          render(conn, "ok.json", %{tweet: updated_tweet})

        {:error, reason} ->
          Logger. error "Error during update tweet(id# #{inspect id}) likes. Error: #{inspect reason}"
          render(conn, "error.json")
      end
    else
      Logger. error "Attempt to updates likes by unauthorized client"
      render(conn, "error.json")
    end
  end

  def update(conn, %{"id" => id} = params) do
    tweet = Tweets.get_tweet!(id)

    case Tweets.update_tweet(tweet, params) do
      {:ok, %Tweet{id: tweet_id} = updated_tweet} ->
        Logger.info "Tweet(id# #{tweet_id}) succesful update."
        render(conn, "ok.json", %{tweet: updated_tweet})

      {:error, reason} ->
        Logger. error "Error during update tweet(id# #{inspect id}). Error: #{inspect reason}"
        render(conn, "error.json")
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> Tweets.get_tweet!()
    |> Tweets.delete_tweet()

    Logger.info "Tweet(id# #{inspect id}) succesful delete."
    render(conn, "ok.json")
  end

  # Для получения текущего пользователя.
  # При расширени можно вынести в отдельный модуль и его импортировать в нужные контроллеры
  defp get_curent_user(conn), do: Guardian.Plug.current_resource(conn)
end