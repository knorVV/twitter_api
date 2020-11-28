defmodule TwitterApi.Tweets.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  embedded_schema do
    field :reply_to_tweet, :string # Текст ответа на твит
  end

  def changeset(%Reply{} = reply, attrs) do
    reply
    |> cast(attrs, [:reply_to_tweet])
  end
end