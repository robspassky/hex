defmodule Mix.Tasks.Hex.User.Register do
  use Mix.Task
  alias Mix.Tasks.Hex.Util

  @shortdoc "Register a new hex user"

  @moduledoc """
  Registers a new hex user.

  `mix hex.user.register`
  """

  def run(_args) do
    Mix.shell.info("Register a new user")
    username = Mix.shell.prompt("Username:") |> String.strip
    email    = Mix.shell.prompt("Email:")    |> String.strip
    password = Mix.shell.prompt("Password:") |> String.strip

    unless nil?(password) do
      confirm = Mix.shell.prompt("Password (confirm):") |> String.strip
      if password != confirm do
        raise Mix.Error, message: "Entered passwords do not match"
      end
    end

    Mix.shell.info("Registering...")
    Hex.start_api
    create_user(username, email, password)
  end

  defp create_user(username, email, password) do
    case Hex.API.new_user(username, email, password) do
      { 201, _ } ->
        Mix.shell.info("Registration of user #{username} was successful!")
        Util.update_config([username: username, password: password])
      { code, body } ->
        Mix.shell.error("Registration of user #{username} failed! (#{code})")
        Util.print_error_result(code, body)
    end
  end
end
