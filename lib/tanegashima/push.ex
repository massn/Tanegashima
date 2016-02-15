defmodule Tanegashima.Push do
  @moduledoc"""
  Elixir wrapper for 'Pushbullet'.
  """
  @push_api "https://api.pushbullet.com/v2/pushes"
  def get do
    case HTTPoison.get(@push_api, [{"Access-Token", push_bullet_token}]) do
      {:ok, %{status_code: 200, body: body}} ->
        Poison.decode(body, as: %{})
      other -> :error
    end
  end

  def delete_all do
   case HTTPoison.delete(@push_api, [{"Access-Token", push_bullet_token}]) do
      {:ok, %{status_code: 200, body: response}} ->
        Poison.decode(response, as: %{})
      {:error, _} = err -> err
    end
  end

  def post options \\ [] do
     {:ok, body} = Poison.encode(to_map options)
     case HTTPoison.post(@push_api, body, [{"Access-Token", push_bullet_token},
                                           {"Content-Type", "application/json"}]) do
      {:ok, %{status_code: 200, body: response}} ->
        Poison.decode(response, as: %{})
      {:error, _} = err -> err
    end
  end

  defp push_bullet_token do
    conf = Mix.Config.read!("config/config.exs")
    conf[:tanegashima][:push_bullet_token]
  end

  defp to_map options do
    body = Keyword.get(options, :body, "bang!")
    title = Keyword.get(options, :title, "Alert")
    type = Keyword.get(options, :type, "note")
    %{"body" => body, "title" => title, "type" => type}
  end

end
