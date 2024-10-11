defmodule TimeManager.Workingtimes.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :start, :naive_datetime
    field :end, :naive_datetime

    belongs_to :user, TimeManager.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_required([:start, :end, :user_id])
    |> validate_start_before_end()
  end

  def update_changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
    |> validate_start_before_end()
  end

  defp validate_start_before_end(changeset) do
    start = get_field(changeset, :start)
    end_time = get_field(changeset, :end)

    if start && end_time && start >= end_time do
      add_error(changeset, :start, "must be before end time")
    else
      changeset
    end
  end
end
