defmodule TwitterApiWeb.ReplyView do
  use TwitterApiWeb, :view

  def render("ok.json", _), do: %{status: :ok}

  def render("error.json", _), do: %{status: :error}
end