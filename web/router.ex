defmodule Wwwtech.Router do
  use Wwwtech.Web, :router

  pipeline :browser do
    plug :accepts, ["html", "atom"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "html"]
  end

  scope "/", Wwwtech do
    pipe_through :browser # Use the default browser stack

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete

    get "/", PageController, :index
    get "/software", PageController, :software
    get "/about", PageController, :about
    get "/whatsnew.atom", PageController, :index_atom

    resources "/notes", NoteController
    get "/notes.atom", NoteController, :index_atom

    resources "/articles", ArticleController, except: [:show]
    get "/articles/:year/:mon/:slug", ArticleController, :show
    get "/articles.atom", ArticleController, :index_atom

    resources "/pictures", PictureController
    get "/pictures.atom", PictureController, :index_atom
  end

  scope "/", Wwwtech do
    pipe_through :api

    post "/webmentions", WebmentionController, :mention
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wwwtech do
  #   pipe_through :api
  # end
end
