defmodule VideoTutorials.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      name: "Video Tutorials Platform",
      source_url: "https://github.com/nicholasjhenry/practical-microservices-ex",
      homepage_url: "https://pragprog.com/titles/egmicro/practical-microservices/",
      dialyzer: [
        ignore_warnings: "dialyzer.ignore-warnings",
        plt_add_apps: [:mix]
      ],
      apps: [
        :creators_portal_web,
        :video_tutorials_back_office,
        :video_tutorials_data,
        :video_tutorials_proxy,
        :video_tutorials_services,
        :video_tutorials_web
      ],
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      docs: docs(),
      releases: releases(),
      default_release: :video_tutorials_prod
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp deps do
    [ ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  #
  # Aliases listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp aliases do
    [
      # run `mix setup` in all child apps
      setup: ["cmd mix setup"],
      docs: ["docs --formatter html", "cmd mix docs --formatter html"],
      check: ["compile --force", "dialyzer", "credo"]
    ]
  end

  defp docs do
    [
      main: "overview",
      authors: ["Nicholas Henry"],
      extra_section: "GUIDES",
      api_reference: false,
      extras: extras(),
      ignore_apps: [
        :creators_portal_web,
        :video_tutorials_back_office,
        :video_tutorials_data,
        :video_tutorials_proxy,
        :video_tutorials_services,
        :video_tutorials_utils,
        :video_tutorials_web
      ]
    ]
  end

  defp extras do
    [
      "guides/overview.md": [title: "Overview"],
      "guides/heroku.md": [title: "Deploy to Heroku"],
      "guides/resources.md": [title: "Resources"]
    ]
  end

  defp releases do
    [
      video_tutorials_prod: [
        include_executables_for: [:unix],
        applications: [
          creators_portal_web: :permanent,
          video_tutorials_back_office: :permanent,
          video_tutorials_data: :permanent,
          video_tutorials_proxy: :permanent,
          video_tutorials_services: :permanent,
          video_tutorials_web: :permanent
        ]
      ],
      video_tutorials_frontend: [
        include_executables_for: [:unix],
        applications: [
          creators_portal_web: :permanent,
          video_tutorials_back_office: :permanent,
          video_tutorials_data: :permanent,
          video_tutorials_proxy: :permanent,
          video_tutorials_web: :permanent
        ]
      ],
      video_tutorials_backend: [
        include_executables_for: [:unix],
        applications: [
          video_tutorials_data: :permanent,
          video_tutorials_services: :permanent
        ]
      ]
    ]
  end
end
