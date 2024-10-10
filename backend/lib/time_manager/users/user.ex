defmodule TimeManager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string

    has_one :clock, TimeManager.Clocks.Clock
    has_many :workingtimes, TimeManager.Workingtimes.Workingtime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
  end
end
