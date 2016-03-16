defmodule Tanegashima.Mixfile do
  use Mix.Project
  def project do
    [app: :tanegashima,
     version: "0.0.10",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Elixir wrapper for Pushbullet-API",
     package: [
       maintainers: ["Massn"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/massn/Tanegashima"}
       ],
     deps: deps]
  end

  def application do
    [applications: [:httpoison, :gun]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8.1"},
      {:poison, "~> 2.1"},
      {:gun, "~> 1.0.0-pre.1"},

      {:dialyze, "~> 0.2.0"},
      {:ex_doc, "~> 0.11.4"},
      {:earmark, ">= 0.0.0"}
    ]
  end
end
