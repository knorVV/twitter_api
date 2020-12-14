defmodule TwitterApi.Tweets.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias TwitterApi.Accounts.User
  alias TwitterApi.Tweets.Reply

  @derive {Jason.Encoder, only: [:tweet_text, :likes, :reply]}

  schema "tweets" do
    field :tweet_text, :string # Текст сообщения
    field :likes, :integer, default: 0 # Количество лайков
    embeds_many :reply, Reply, on_replace: :delete # Ответы на твит
    belongs_to :user, User # Ссылка на пользователя

    timestamps()
  end

  @doc false
  def changeset(%Tweet{} = tweet, attrs) do
    tweet
    |> cast(attrs, [:tweet_text, :likes, :user_id])
    |> validate_required([:tweet_text, :user_id])
  end
end
