defmodule TwitterApiWeb.Router do
  use TwitterApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected_api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :accounts
    plug :ensure_accounts
  end

  pipeline :accounts do
    plug TwitterApiWeb.Auth.Pipeline
  end

  pipeline :ensure_accounts do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", TwitterApiWeb do
    pipe_through :api

    scope "/auth" do
      post "/login", AuthController, :login
      delete "/logout", AuthController, :logout
    end

    put "/tweets/:id/likes", TweetsController, :likes_update
    resources "/:tweet_id/reply", ReplyController

    scope "/tweets" do
      pipe_through :protected_api

      get "/:id", TweetsController, :show
      resources "/", TweetsController, except: [:show]
    end
  end
end
