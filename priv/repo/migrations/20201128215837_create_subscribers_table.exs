defmodule TwitterApi.Repo.Migrations.CreateSubscribersTable do
  use Ecto.Migration

  def change do
    create table(:subscribers, primary_key: false) do
      add :user_id, references(:users, on_delete: :nothing)
      add :subscribed_id, references(:users, on_delete: :nothing)
    end

    create index(:subscribers, [:user_id])
    create index(:subscribers, [:subscribed_id])
  end
end
