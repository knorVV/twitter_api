defmodule TwitterApiWeb.TweetsView do
  use TwitterApiWeb, :view

  def render("ok.json", %{tweet: tweet}) do
    %{tweet: tweet}
  end

  def render("ok.json", %{tweets: tweets}) do
    %{tweets: tweets}
  end

  def render("ok.json", _) do
    %{status: :ok}
  end

  def render("error.json", _) do
    %{error: "error"}
  end
end