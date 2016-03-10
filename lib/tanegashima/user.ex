defmodule Tanegashima.User do
  @moduledoc"""
  Elixir wrapper for Pushbullet-User-API.
  """

  defstruct [:active, :created, :email, :email_normalized, :iden, :image_url, :max_upload_size,
             :modified, :name, :referred_count, :referrer_iden]

  @type t :: %__MODULE__{}

  @user_api "https://api.pushbullet.com/v2/users/me"

  @doc"""
  get the user of me.
  """
  @spec get :: {:ok, Tanegashima.User.t} | {:error, term}
  def get do
    with {:ok, %{status_code: status_code, body: response}}
             <- HTTPoison.get(@user_api, [{"Access-Token", Tanegashima.access_token}]),
         {:error, [status_code: 200, response: ^response]}
             <- {:error, [status_code: status_code, response: response]},
         {:ok, poison_struct} <- Poison.decode(response, as: %{}),
         {:ok, user_struct} <- Tanegashima.to_struct(Tanegashima.User, poison_struct),
         do: {:ok, user_struct}
  end

end
