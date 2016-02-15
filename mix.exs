defmodule Tanegashima.Mixfile do
  use Mix.Project
  def project do
    [app: :tanegashima,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Elixir wrapper for pushbullet-API",
     package: [
       maintainers: ["Massn"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/massn/Tanegashima"}
       ],
     deps: deps]
  end

  def application do
    [applications: [:httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8.1"},
      {:poison, "~> 2.1"},

      #:dialyxir, "~> 0.3.3"},
      {:dialyze, "~> 0.2.0"},
      {:ex_doc, "~> 0.11.4"},
      {:earmark, ">= 0.0.0"}
    ]
  end
end
