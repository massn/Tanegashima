defmodule Tanegashima.Example.Websocket do
  @moduledoc"""
  Example of `Tanegashima.Websocket` implementation.
  When you get push-tickle, it will get the latest push.
  usage:

      iex> Tanegashima.Example.Websocket.start

  """
  use Tanegashima.Websocket

  def handle_push state do
    {:ok, [%{body: body}]} = Tanegashima.Push.get([limit: "1"])
    IO.puts "got push body:#{body}"
    state
  end

  def handle_other_message msg, state do
    IO.puts "other message #{inspect(msg)}"
    state
  end

end


