defmodule PipsqueakWeb.PageController do
  use PipsqueakWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html",
      to_echo: "silly billy",
      list: [
        "bg-red-500",
        "bg-blue-500",
        "bg-pink-500",
        "bg-teal-500",
        "bg-yellow-500",
        "bg-purple-500"
      ]
    )
  end

  def echo(conn, %{"echo" => to_echo}) do
    json(conn, %{
      echo: to_echo
    })
  end
end
