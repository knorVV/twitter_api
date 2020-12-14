defmodule TwitterApiWeb.Support.Utils do
  @moduledoc false

  @doc """
    Генерит рандомный email
  """
  @spec random_email :: String.t()
  def random_email do
    email_head =
      :rand.uniform(10)
      |> random_string()

    "#{email_head}@email.email"
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length)
      |> Base.encode64
      |> binary_part(0, length)
      |> String.replace("/", "")
  end
end