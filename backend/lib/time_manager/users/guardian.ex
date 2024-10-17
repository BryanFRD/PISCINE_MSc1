defmodule TimeManager.Users.Guardian do
  use Guardian, otp_app: :time_manager

  alias TimeManager.Users

  def subject_for_token(%Users.User{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_subject}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Users.get_user(id) do
      nil -> {:error, :unauthorized}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_) do
    {:error, :invalid_claims}
  end
end
