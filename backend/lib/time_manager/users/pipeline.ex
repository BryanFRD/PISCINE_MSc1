defmodule TimeManager.Users.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :time_manager,
    error_handler: TimeManager.Users.ErrorHandler,
    module: TimeManager.Users.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
