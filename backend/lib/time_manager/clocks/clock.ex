defmodule TimeManager.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime

    belongs_to :user, TimeManager.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status])
    |> maybe_validate_time()
    |> maybe_validate_status()
  end

  defp maybe_validate_time(changeset) do
    if get_change(changeset, :time) do
      changeset
      |> validate_required([:time])
      |> validate_format(:time, ~r/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/,
        message: "must be in the format YYYY-MM-DD HH:MM:SS"
      )
    else
      changeset
    end
  end

  defp maybe_validate_status(changeset) do
    if get_change(changeset, :status) do
      changeset
      |> validate_required([:status])
    else
      changeset
    end
  end
end
