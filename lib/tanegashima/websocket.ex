defmodule Tanegashima.Websocket do
  @moduledoc"""
  Elixir wrapper for Pushbullet-Websocket-API.
  You can do nothing other than override-defining `handle_push` and `handle_other_message` for nomal use.
  usage:

      defmodule Examaple do
        use Tanegashima.Websocket
      end

  and

      iex> Example.start

  """

  @doc"""
  State of your Websocket GenServer.
  """
  @type state :: map

  @doc"""
  The initial state of your GenServer.
  """
  @callback initial_state :: state
  @doc"""
  Handle your state when you get push-tickle notification.
  """
  @callback handle_push(state) :: state
  @doc"""
  Handle your state when you get other than push or nop notification.
  """
  @callback handle_other_message(binary, state) :: state

  @doc false
  defmacro __using__(_) do
    quote do
      @behaviour Tanegashima.Websocket
      use GenServer
      @host "stream.pushbullet.com"

      @doc"""
      Start websocket server.
      """
      def start do
        GenServer.start_link(__MODULE__, [initial_state], [name: __MODULE__])
      end

      @doc"""
      Stop websocket server.
      """
      def stop, do: GenServer.stop(__MODULE__)

      @doc "The initial state of your GenServer."
      def initial_state, do: %{}

      @doc false
      def handle_gun_message({:gun_ws_upgrade, _, :ok, _}, state), do: state
      def handle_gun_message({:gun_up, _, _}, state), do: state
      def handle_gun_message({:gun_ws, _, {:text, message_text}} = message, state) do
        message_map = message_to_map(message_text)
        type = message_map["type"]
        subtype = message_map["subtype"]
        cond do
          type == "nop" -> state
          type == "tickle" and subtype == "push" -> handle_push state
          true -> handle_other_message message, state
        end
      end

      @doc false
      def handle_push(state), do: state
      def handle_other_message(_other_msg, state), do: state

      @doc false
      def init [initial_state] do
        {:ok, conn} =:gun.open(to_char_list(@host), 443)
        :gun.ws_upgrade(conn, to_char_list("/websocket/#{Tanegashima.access_token}"))
        {:ok, Map.put(initial_state, :conn, conn)}
      end

      @doc false
      def handle_info(msg, state), do: {:noreply, handle_gun_message(msg, state)}

      defp message_to_map message do
        key_and_values = for word <- String.split(message, ["\"", "{", "}", ",", ":", " "]),
                             word != "", do: word
        Enum.reduce(0..div(length(key_and_values), 2), {key_and_values, %{}},
          fn(_, {[key, value|rest], acc_map}) -> {rest, Map.put(acc_map, key, value)}
            (_, {_, acc_map}) -> acc_map
          end)
      end

      defoverridable [initial_state: 0, handle_gun_message: 2, handle_push: 1, handle_other_message: 2]
    end
  end
end
