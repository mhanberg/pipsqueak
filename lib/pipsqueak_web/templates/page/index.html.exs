header do
  x = :foo

  {:ok, agent} = Agent.start(fn -> [] end)

  div do
    section class: "grid gap-4 grid-cols-2" do
      for x <- @list do
        :ok = Agent.update(agent, fn state -> [x | state] end)

        div class: x <> " w-full" do
          x
        end
      end
    end

    div do
      Agent.get(agent, fn state -> state end) |> inspect
    end
  end
end

live_render(@conn, PipsqueakWeb.DemoLive)
