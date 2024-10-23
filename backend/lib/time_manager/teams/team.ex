defmodule TimeManager.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string

    many_to_many :managers, TimeManager.Users.User,
      join_through: "teams_managers",
      on_replace: :delete

    many_to_many :users, TimeManager.Users.User, join_through: "teams_users", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> maybe_validate_name()
    |> put_user_ids(attrs["user_ids"])
    |> put_manager_ids(attrs["manager_ids"])
  end

  defp maybe_validate_name(changeset) do
    if get_change(changeset, :name) do
      changeset
      |> validate_required([:name])
      |> validate_length(:name, min: 3, max: 30)
    else
      changeset
    end
  end

  defp put_user_ids(changeset, user_ids) when is_list(user_ids) do
    changeset = Ecto.Changeset.change(changeset.data |> TimeManager.Repo.preload(:users))

    changeset
    |> put_assoc(:users, Enum.map(user_ids, &TimeManager.Users.get_user!/1))
  end

  defp put_user_ids(changeset, nil), do: changeset
  defp put_user_ids(changeset, _), do: changeset

  defp put_manager_ids(changeset, manager_ids) when is_list(manager_ids) do
    if length(manager_ids) > 0 do
      changeset = Ecto.Changeset.change(changeset.data |> TimeManager.Repo.preload(:managers))

      changeset
      |> put_assoc(:managers, Enum.map(manager_ids, &TimeManager.Users.get_user!/1))
    else
      add_error(changeset, :managers, "must have at least one manager")
    end
  end

  defp put_manager_ids(changeset, nil), do: changeset
  defp put_manager_ids(changeset, _), do: changeset
end
