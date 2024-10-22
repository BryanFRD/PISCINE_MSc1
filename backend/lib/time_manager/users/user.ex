defmodule TimeManager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :password_confirmation, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true

    has_one :clock, TimeManager.Clocks.Clock
    has_many :workingtimes, TimeManager.Workingtimes.Workingtime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :password_confirmation])
    |> maybe_validate_username()
    |> maybe_validate_email()
    |> maybe_validate_password()
  end

  defp maybe_validate_username(changeset) do
    if get_change(changeset, :username) do
      changeset
      |> validate_required([:username])
      |> validate_length(:username, min: 3, max: 30)
    else
      changeset
    end
  end

  defp maybe_validate_email(changeset) do
    if get_change(changeset, :email) do
      changeset
      |> validate_required([:email])
      |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/,
        message: "must have the @ sign and no spaces"
      )
      |> validate_length(:email, max: 160)
      |> unsafe_validate_unique(:email, TimeManager.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  defp maybe_validate_password(changeset) do
    if get_change(changeset, :password) do
      changeset
      |> validate_required([:password, :password_confirmation])
      |> validate_length(:password, min: 12, max: 72)
      |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
      |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
      |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
        message: "at least one digit or punctuation character"
      )
      |> validate_confirmation(:password)
      |> maybe_hash_password()
    else
      changeset
    end
  end

  defp maybe_hash_password(changeset) do
    password = get_change(changeset, :password)

    if changeset.valid? do
      changeset
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
