defmodule PipsqueakWeb.PageView do
  use PipsqueakWeb, :view

  def source_version do
    System.get_env("SOURCE_VERSION")
  end
end
