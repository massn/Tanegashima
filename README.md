# Tanegashima

Elixir wrapper for [Pushbullet](https://www.pushbullet.com/).

## Installation

[Available in Hex](https://hex.pm).

The package can be installed as:

  * Add tanegashima to your list of dependencies in `mix.exs`:

        def deps do
          [{:tanegashima, "~> 0.0.5"}]
        end

## Usage

1. Copy your pushbullet-Access-Token from [here](https://www.pushbullet.com/#settings) and paste it in `config/config.exs` in your project. `config/config_template.exs` will be helpful.
```elixir
config :tanegashima,
    access_token: "abc.defg123456789"
```
1.
In `mix.exs` in your project,
```elixir
def application do
     [applications: [:tanegashima]]
end
```
1.  You can use pushbullet-API. Like ...
```bash
iex> Tanegashima.Push.post body: "hello from Tanegashima!"
{:ok, %Tanegashima.Push{"active" => true, "body" => "hello from Tanegashima!", ...}
# You will get the notification on your Android or iPhone which installed Pushbullet apps.
```
