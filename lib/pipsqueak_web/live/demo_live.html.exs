div do
  range = 1..5

  for _ <- range do
    div do
      "Current temperature #{@temperature}"
    end
  end

  string = "increase"

  button phx_click: "increase" do
    span do
      "beans"
    end
  end

  htm = "<div>hi</div>"

  div do
    htm
  end
end
