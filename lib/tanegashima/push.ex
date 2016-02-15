defmodule Tanegashima.Push do
  @moduledoc"""
  Elixir wrapper for Pushbullet-Push-API.
  """

  @type parameters :: [{:type|:title|:body|:url|:file_name|:file_type|:file_url , binary}]

  @push_api "https://api.pushbullet.com/v2/pushes"

  @doc"""
  get pushes.
  """
  @spec get :: {:ok, Poison.Parser.t} | {:error, term}
  def get do
    case HTTPoison.get(@push_api, [{"Access-Token", push_bullet_token}]) do
      {:ok, %{status_code: 200, body: body}} ->
        Poison.decode(body, as: %{})
      error -> error
    end
  end

  @doc"""
  delete all pushes.
  """
  @spec delete_all :: {:ok, Poison.Parser.t} | {:error, term}
  def delete_all do
   case HTTPoison.delete(@push_api, [{"Access-Token", push_bullet_token}]) do
      {:ok, %{status_code: 200, body: response}} ->
        Poison.decode(response, as: %{})
      error -> error
    end
  end

  @doc"""
  post push.
  """
  @spec post(parameters) :: {:ok, Poison.Parser.t} | {:error, term}
  def post parameters \\ [] do
     {:ok, body} = Poison.encode(to_map parameters)
     case HTTPoison.post(@push_api, body, [{"Access-Token", push_bullet_token},
                                           {"Content-Type", "application/json"}]) do
      {:ok, %{status_code: 200, body: response}} ->
        Poison.decode(response, as: %{})
      error -> error
    end
  end

  defp push_bullet_token do
    conf = Mix.Config.read!("config/config.exs")
    conf[:tanegashima][:push_bullet_token]
  end

  defp to_map parameters do
    Enum.reduce(parameters,
                %{"body" => "bang!", "title" => "Alert", "type" => "note"},
                fn({key, val}, acc) -> Map.put(acc, :erlang.atom_to_binary(key, :utf8), val) end)
  end

end
