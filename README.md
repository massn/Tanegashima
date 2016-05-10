# Tanegashima

Elixir wrapper for [Pushbullet](https://www.pushbullet.com/).

## Installation

[Available in Hex](https://hex.pm).

The package can be installed as:

  * Add tanegashima to your list of dependencies in `mix.exs`:

        def deps do
          [{:tanegashima, "~> 0.0.11"}]
        end

## Usage

Copy your pushbullet-Access-Token from [here](https://www.pushbullet.com/#settings) and paste it in `config/config.exs` in your project. `config/config_template.exs` will be helpful.
```elixir
config :tanegashima,
    access_token: "abc.defg123456789"
```
In `mix.exs` in your project,
```elixir
def application do
     [applications: [:tanegashima]]
end
```

## Examples

#### Post a push
You will get the notification on your Android or iPhone which installed Pushbullet apps.


```bash
iex> Tanegashima.Push.post body: "hello from Tanegashima!"
{:ok, %Tanegashima.Push{"active" => true, "body" => "hello from Tanegashima!", ...}
```

#### Get a push-notification from websocket

You can implement callbacks of websocket-tickle with `use Tanegashima.Websocket` in your module like `Tanegashima.Example.Websocket`.
```bash
iex> Tanegashima.Example.Websocket.start
```
