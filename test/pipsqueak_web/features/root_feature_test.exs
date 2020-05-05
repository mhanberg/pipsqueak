defmodule PipsqueakWeb.RootFeatureTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  feature "the home page exists", %{session: session} do
    session
    |> IO.inspect(label: "###########")
    |> visit("/")
    |> assert_text("Current temperature 0")

    session
    |> click(Query.button("increase") |> IO.inspect(pretty: true))
    |> (fn s ->
          Process.sleep(2000)
          s
        end).()
    |> assert_text("Current temperature 1")
  end
end
