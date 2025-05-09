defmodule TwitterApi.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :tweet, :text
      add :likes, :integer, default: 0
      add :reply, {:array, :map}, default: []
      add :user_id, references(:users, on_delete: nothing)

      timestamps()
    end

    create index(:tweets, [:user_id])
  end
end
