defmodule TwitterApiWeb.TweetsView do
  use TwitterApiWeb, :view

  def render("ok.json", %{tweet: tweet}), do: %{tweet: tweet}

  def render("ok.json", %{tweets: tweets}), do: %{tweets: tweets}

  def render("ok.json", _), do: %{status: :ok}

  def render("error.json", _), do: %{status: :error}
end