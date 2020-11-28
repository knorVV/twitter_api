defmodule TwitterApi.Algo.LikesCalculatingAlgorithm do
  @moduledoc """
    Here calculating likes
  """
  alias TwitterApi.Tweets.Tweet

  def calc_likes(%Tweet{likes: current_likes}, likes) when is_integer(likes) do
    current_likes + likes
  end

  def calc_likes(%Tweet{likes: current_likes}, likes) do
    current_likes + String.to_integer(likes)
  end
end