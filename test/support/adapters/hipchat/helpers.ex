defmodule Cog.Adapters.HipChat.Helpers do
  alias Cog.Adapters.HipChat
  alias Cog.Assertions
  alias Cog.Models.User

  @bot_handle "deckard"
  @room "ci_bot_testing"
  @interval 5000 # 5 seconds
  @timeout 120000 # 2 minutes

  def send_message(%User{username: _username}, message) do
    HipChat.send_message(%{"id" => @room}, message)
  end

  def assert_response(message, [after: %{"id" => id}]) do
    :timer.sleep(@interval)

    last_message_func = fn ->
      HipChat.API.retrieve_last_message(@room, id)
    end

    Assertions.polling_assert(message, last_message_func, @interval, @timeout)
  end
end
