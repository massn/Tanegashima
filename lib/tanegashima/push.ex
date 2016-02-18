defmodule Tanegashima.Push do
  @moduledoc"""
  Elixir wrapper for Pushbullet-Push-API.
  """

  defstruct active: nil, body: nil, created: nil, direction: nil, dismissed: nil, iden: nil,
            modified: nil, receiver_email: nil, receiver_email_normalized: nil,
            receiver_iden: nil, sender_email: nil, sender_email_normalized: nil,
            sender_iden: nil, sender_name: nil, title: nil, type: nil
  @type t :: %__MODULE__{}
  @type parameters :: [{:type|:title|:body|:url|:file_name|:file_type|:file_url , binary}]

  @push_api "https://api.pushbullet.com/v2/pushes"

  @doc"""
  get pushes.
  """
  @spec get :: {:ok, Tanegashima.t} | {:error, term}
  def get do
    with {:ok, %{status_code: status_code, body: body}}
             <- HTTPoison.get(@push_api, [{"Access-Token", Tanegashima.access_token}]),
         {:error, [status_code: 200]} <- {:error, [status_code: status_code]},
         {:ok, poison_struct} <- Poison.decode(body, as: %{}),
         do: Tanegashima.to_struct Tanegashima, poison_struct
  end

  @doc"""
  delete all pushes.
  """
  @spec delete_all :: :ok | {:error, term}
  def delete_all do
   with {:ok, %{status_code: status_code, body: response}}
            <- HTTPoison.delete(@push_api, [{"Access-Token", Tanegashima.access_token}]),
        {:error, [status_code: 200]} <- {:error, [status_code: status_code]},
        {:error, [response: "{}"]} <- {:error, [response: response]},
        do: :ok
  end

  @doc"""
  post push.
  """
  @spec post(parameters) :: {:ok, t} | {:error, term}
  def post parameters \\ [] do
     with {:ok, body} <- Poison.encode(to_map parameters),
          {:ok, %{status_code: status_code, body: response}}
              <- HTTPoison.post(@push_api, body, [{"Access-Token", Tanegashima.access_token},
                                                  {"Content-Type", "application/json"}]),
          {:error, [status_code: 200]} <- {:error, [status_code: status_code]},
          {:ok, poison_struct} <- Poison.decode(response, as: %{}),
          do: Tanegashima.to_struct Tanegashima.Push, poison_struct
  end

  defp to_map parameters do
    Enum.reduce(parameters,
    %{"body" => "bang!", "title" => "Alert", "type" => "note"},
    fn({key, val}, acc) -> Map.put(acc, :erlang.atom_to_binary(key, :utf8), val) end)
  end

end
