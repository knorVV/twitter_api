defmodule TwitterApi.Repo.Migrations.AddUserIdsFieldToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :user_ids, {:array, :integer}
    end

    create index(:users, [:user_ids])
  end
end
