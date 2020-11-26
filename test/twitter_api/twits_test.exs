defmodule TwitterApi.TwitsTest do
  use TwitterApi.DataCase

  alias TwitterApi.Twits

  describe "twits" do
    alias TwitterApi.Twits.Twit

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def twit_fixture(attrs \\ %{}) do
      {:ok, twit} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Twits.create_twit()

      twit
    end

    test "list_twits/0 returns all twits" do
      twit = twit_fixture()
      assert Twits.list_twits() == [twit]
    end

    test "get_twit!/1 returns the twit with given id" do
      twit = twit_fixture()
      assert Twits.get_twit!(twit.id) == twit
    end

    test "create_twit/1 with valid data creates a twit" do
      assert {:ok, %Twit{} = twit} = Twits.create_twit(@valid_attrs)
    end

    test "create_twit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Twits.create_twit(@invalid_attrs)
    end

    test "update_twit/2 with valid data updates the twit" do
      twit = twit_fixture()
      assert {:ok, %Twit{} = twit} = Twits.update_twit(twit, @update_attrs)
    end

    test "update_twit/2 with invalid data returns error changeset" do
      twit = twit_fixture()
      assert {:error, %Ecto.Changeset{}} = Twits.update_twit(twit, @invalid_attrs)
      assert twit == Twits.get_twit!(twit.id)
    end

    test "delete_twit/1 deletes the twit" do
      twit = twit_fixture()
      assert {:ok, %Twit{}} = Twits.delete_twit(twit)
      assert_raise Ecto.NoResultsError, fn -> Twits.get_twit!(twit.id) end
    end

    test "change_twit/1 returns a twit changeset" do
      twit = twit_fixture()
      assert %Ecto.Changeset{} = Twits.change_twit(twit)
    end
  end
end
