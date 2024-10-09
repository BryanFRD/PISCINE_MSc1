defmodule TimeManager.Workingtimes do
  @moduledoc """
  The Workingtimes context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Workingtimes.Workingtime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%Workingtime{}, ...]

  """
  def list_user_workingtimes(user_id, params \\ %{}) do
    query =
      Workingtime
      |> where([w], w.user_id == ^user_id)
      |> maybe_filter_by_start(params["start"])
      |> maybe_filter_by_end(params["end"])

    Repo.all(query)
  end

  # Filter by start
  defp maybe_filter_by_start(query, nil), do: query

  defp maybe_filter_by_start(query, start), do: from(w in query, where: w.start >= ^start)

  # Filter by end
  defp maybe_filter_by_end(query, nil), do: query

  defp maybe_filter_by_end(query, end_param),
    do: from(w in query, where: field(w, :end) <= ^end_param)

  @doc """
  Gets a single workingtime.

  Raises `Ecto.NoResultsError` if the Workingtime does not exist.

  ## Examples

      iex> get_workingtime!(123)
      %Workingtime{}

      iex> get_workingtime!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workingtime!(id), do: Repo.get!(Workingtime, id)

  @doc """
  Gets a single user workingtime.

  Raises `Ecto.NoResultsError` if the Workingtime does not exist.

  ## Examples

      iex> get_workingtime!(1, 123)
      %Workingtime{}

      iex> get_workingtime!(1, 456)
      ** (Ecto.NoResultsError)

  """
  def get_user_workingtime!(user_id, id) do
    Workingtime
    |> where([w], w.user_id == ^user_id and w.id == ^id)
    |> Repo.one!()
  end

  @doc """
  Creates a workingtime.

  ## Examples

      iex> create_workingtime(%{field: value})
      {:ok, %Workingtime{}}

      iex> create_workingtime(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workingtime(attrs \\ %{}) do
    %Workingtime{}
    |> Workingtime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workingtime.

  ## Examples

      iex> update_workingtime(workingtime, %{field: new_value})
      {:ok, %Workingtime{}}

      iex> update_workingtime(workingtime, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workingtime.

  ## Examples

      iex> delete_workingtime(workingtime)
      {:ok, %Workingtime{}}

      iex> delete_workingtime(workingtime)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtime changes.

  ## Examples

      iex> change_workingtime(workingtime)
      %Ecto.Changeset{data: %Workingtime{}}

  """
  def change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.changeset(workingtime, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtime update changes.

  ## Examples

      iex> change_workingtime(workingtime)
      %Ecto.Changeset{data: %Workingtime{}}

  """
  def update_change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.update_changeset(workingtime, attrs)
  end
end
