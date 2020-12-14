defmodule TwitterApiWeb.Auth.Guardian do
  use Guardian, otp_app: :twitter_api
  alias TwitterApi.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    {:ok, Accounts.get_bare_user!(claims["sub"])}
    # If something goes wrong here return {:error, reason}
  end
end