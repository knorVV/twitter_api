defmodule TwitterApiWeb.AuthView do
  use TwitterApiWeb, :view

  def render("ok.json", _), do: %{status: :ok}

  def render("unauthorized.json", _), do: %{status: :unauthorized}
end