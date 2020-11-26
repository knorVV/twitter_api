defmodule TwitterApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias TwitterApi.Twits.Twit

  # Длина пароля от 8 до 16 символов. Только латинские буквы и цифры.
  @password ~r/^[a-zA-Z0-9~!@#$%^&*()_+=\-?:;,.<>\\|\/]{8,16}$/

  schema "users" do
    field :username, :string # ник
    field :email, :string # Адрес ЭП
    field :second_name, :string # Фамилия
    field :first_name, :string # Имя
    field :middle_name, :string # Отчество/Второе имя
    has_many :twits, Twit # Твиты

    #Пароль
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :second_name, :first_name, :middle_name, :password])
    |> validate_format(:password, @password)
    |> put_password_hash()
    |> validate_required([:email, :password_hash])
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ -> changeset
    end
  end
end
