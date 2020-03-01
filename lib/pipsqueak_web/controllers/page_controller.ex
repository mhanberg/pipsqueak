defmodule PipsqueakWeb.PageController do
  use PipsqueakWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
