defmodule TwitterApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :second_name, :string
      add :first_name, :string
      add :middle_name, :string
      add :password_hash, :string
      
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
