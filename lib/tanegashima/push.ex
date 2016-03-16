defmodule Tanegashima.Push do
  @moduledoc"""
  Elixir wrapper for Pushbullet-Push-API.
  """

  defstruct [:active, :awake_app_guids, :body, :channel_iden, :client_iden, :created, :direction,
             :dismissed, :file_name, :file_type, :file_url, :guid, :iden, :image_height, :image_url,
             :image_width, :modified, :receiver_email, :receiver_email_normalized, :receiver_iden,
             :sender_email, :sender_email_normalized, :sender_iden, :sender_name, :source_device_iden,
             :target_device_iden, :title, :type, :url]

  @type t :: %__MODULE__{}
  @type get_parameters :: [{:modified_after|:active|:cursor|:limit, binary}]
  @type post_parameters :: [{:type|:title|:body|:url|:file_name|:file_type|:file_url , binary}]

  @push_api "https://api.pushbullet.com/v2/pushes"

  @doc"""
  get pushes.
  """
  @spec get(get_parameters) :: {:ok, [Tanegashima.Push.t]} | {:error, term}
  def get(parameters \\ [])do
    with {:ok, %{status_code: status_code, body: response}}
           <- HTTPoison.get("#{@push_api}?#{URI.encode_query(parameters)}", [{"Access-Token", Tanegashima.access_token}]),
         {:error, [status_code: 200, response: ^response]}
           <- {:error, [status_code: status_code, response: response]},
         {:ok, poison_struct} <- Poison.decode(response, as: %{}),
         {:ok, %{pushes: pushes}} = Tanegashima.to_struct(Tanegashima, poison_struct)
         do
           push_structs = for push <- pushes do
             {:ok, push_struct} = Tanegashima.to_struct Tanegashima.Push, push
             push_struct
           end
           {:ok, push_structs}
         end
  end

  @doc"""
  delete a push by iden.
  """
  @spec delete(binary) :: :ok | {:error, term}
  def delete(iden), do: _delete "/#{iden}"

  @doc"""
  delete all pushes.
  """
  @spec delete_all :: :ok | {:error, term}
  def delete_all, do: _delete

  @doc"""
  post push.
  """
  @spec post(post_parameters) :: {:ok, t} | {:error, term}
  def post parameters \\ [] do
     with {:ok, body} <- Poison.encode(post_parameters_to_map parameters),
          {:ok, %{status_code: status_code, body: response}}
              <- HTTPoison.post(@push_api, body, [{"Access-Token", Tanegashima.access_token},
                                                  {"Content-Type", "application/json"}]),
          {:error, [status_code: 200, response: ^response]} <- {:error, [status_code: status_code, response: response]},
          {:ok, poison_struct} <- Poison.decode(response, as: %{}),
          do: Tanegashima.to_struct Tanegashima.Push, poison_struct
  end

  defp post_parameters_to_map parameters do
    Enum.reduce(parameters,
    %{"body" => "bang!", "title" => "Alert", "type" => "note"},
    fn({key, val}, acc) -> Map.put(acc, :erlang.atom_to_binary(key, :utf8), val) end)
  end

  defp _delete slash_iden \\ "" do
    with {:ok, %{status_code: status_code, body: response}}
            <- HTTPoison.delete(@push_api <> slash_iden, [{"Access-Token", Tanegashima.access_token}]),
         {:error, [status_code: 200, response: "{}"]} <- {:error, [status_code: status_code, response: response]},
         do: :ok
  end

end
