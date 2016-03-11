defmodule Tanegashima.Device do
  @moduledoc"""
  Elixir wrapper for Pushbullet-Device-API.
  """

  defstruct [:active, :app_version, :created, :fingerprint, :generated_nickname, :has_mms,
             :has_sms, :icon, :iden, :key_fingerprint, :kind, :manufacturer, :model,
             :modified, :nickname, :pushable, :push_token, :remote_filed, :type]

  @type t :: %__MODULE__{}

  @device_api "https://api.pushbullet.com/v2/devices"

  @doc"""
  get devices.
  """
  @spec get :: {:ok, [Tanegashima.Device.t]} | {:error, term}
  def get do
    with {:ok, %{status_code: status_code, body: response}}
             <- HTTPoison.get(@device_api, [{"Access-Token", Tanegashima.access_token}]),
         {:error, [status_code: 200, response: ^response]}
             <- {:error, [status_code: status_code, response: response]},
         {:ok, poison_struct} <- Poison.decode(response, as: %{}),
         {:ok, %{devices: devices}} <- Tanegashima.to_struct(Tanegashima, poison_struct)
         do
           for device <- devices
             do
               {:ok, device_struct} = Tanegashima.to_struct(Tanegashima.Device, device)
               device_struct
             end
         end
  end

end
