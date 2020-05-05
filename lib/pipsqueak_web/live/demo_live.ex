defmodule PipsqueakWeb.DemoLive do
  use PipsqueakWeb, :live

  def mount(_, _, socket) do
    {:ok, assign(socket, :temperature, 0)}
  end

  def handle_event("increase", _, socket) do
    {:noreply, assign(socket, :temperature, socket.assigns.temperature + 1)}
  end

  defp i_eat(func) do
    "i eat " <> func.()
  end

  defp escape(bin) do
    bin 
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> IO.inspect(label: :binary)
  end
end
