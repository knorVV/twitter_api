defmodule TwitterApiWeb.UserView do
  use TwitterApiWeb, :view

  def render("ok.json", %{user: user}), do: %{user: user}

  def render("error.json", _), do: %{status: :error}
end