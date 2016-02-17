defmodule Tanegashima do
  @moduledoc"""
  Pushbullet general objects.
  """
  defstruct accounts: nil, blocks: nil, channels: nil, chats: nil, clients: nil,
            contacts: nil, devices: nil, grants: nil, profiles: nil, pushes: nil,
            subscriptions: nil, texts: nil, cursor: nil

  @doc"""
  Convert Poison struct to Tanegashima(Pushbullet object) struct.
  """
  @spec to_struct(module, Poison.Parser.t) :: {:ok, %Tanegashima{}} | {:error, term}
  def to_struct object_module, poison_struct do
    object_map = Map.from_struct object_module
    binary_struct_keys = for atom_key <- Map.keys(object_map),
                         do: :erlang.atom_to_binary(atom_key, :utf8)
    Enum.reduce(poison_struct,
                {:ok, struct(object_module)},
                fn(_, {:error, _} = err) -> err
                  ({binary_key, val}, {:ok, acc}) ->
                    case Enum.member?(binary_struct_keys, binary_key) do
                      true -> {:ok, %{acc | :erlang.binary_to_existing_atom(binary_key, :utf8) => val}}
                      false -> {:error, [not_object_struct_member: {binary_key, object_module}]}
                    end
                end)
  end

  @doc"""
  Get Pushbullet access token.
  """
  @spec access_token :: binary
  def access_token do
    conf = Mix.Config.read!("config/config.exs")
    conf[:tanegashima][:access_token]
  end

end

