defmodule TwitterApiWeb.ReplyController do
  use TwitterApiWeb, :controller

  alias TwitterApi.Tweets.Replies
  require Logger

  plug :check_authorized

  def create(conn, %{"reply_to_tweet" => reply_to_tweet, "tweet_id" => tweet_id}) do
    case Replies.put_reply_to_tweet(tweet_id, reply_to_tweet) do
      {:ok, tweet} ->
        Logger.info "Reply succesful create"
        render(conn, "ok.json", %{tweet: tweet})

      {:error, reason} ->
        Logger.error "Error during create reply. Error: #{inspect reason}"
        render(conn, "error.json")
    end
  end

  defp check_authorized(conn, _params) do
    if conn.assigns[:authorized] do
      conn
    else
      conn
      |> render("error.json.json")
      |> halt()
    end
  end
end