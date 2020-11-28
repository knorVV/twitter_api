defmodule TwitterApi.Accounts.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias TwitterApi.Accounts.User

  @primary_key false
  schema "subscribers" do
    belongs_to :user, User
    belongs_to :subscribed, User
  end

  def changeset(%Subscriber{} = struct, attrs) do
    struct
    |> cast(attrs, [:user_id, :subscribed_id])
    |> validate_required([:user_id, :subscribed_id])
  end

end