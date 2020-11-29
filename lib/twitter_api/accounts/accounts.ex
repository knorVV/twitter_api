defmodule TwitterApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias TwitterApi.Repo
  alias TwitterApi.Accounts.User

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_bare_user!(123)
      %User{}

      iex> get_bare_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_bare_user!(non_neg_integer()) :: User.t() | any()
  def get_bare_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets user and preload him tweets.

  ## Examples

      iex> get_user(123)
      %User{tweets: %TwitterApi.Tweets.Tweet{}}

      iex> get_user(456)
      nil

  """
  @spec get_user(non_neg_integer()) :: User.t() | nil
  def get_user(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:tweets)
  end

  @doc """
    Get user by email
  """
  @spec get_user_by_email(String.t()) :: User.t() | nil
  def get_user_by_email(email) do
    User
    |> where([u], u.email == ^email)
    |> Repo.one()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(map()) :: {:ok, User.t()} | {:error, any()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user(User.t(), map()) :: {:ok, User.t()} | {:error, any()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, any()}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user(User.t(), map()) :: Ecto.Changeset.t()
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
    Subscription to user
  """
  @spec add_subscription(User.t(), non_neg_integer()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def add_subscription(%User{user_ids: user_ids} = user, subscribed_id) do
    user_ids = [subscribed_id | user_ids]

    update_user(user, %{user_ids: user_ids})
  end
end
