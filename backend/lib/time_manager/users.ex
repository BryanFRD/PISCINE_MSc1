defmodule TimeManager.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Users.Guardian
  alias TimeManager.Repo

  alias TimeManager.Users.User
  alias TimeManager.Clocks.Clock
  alias TimeManager.Teams

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(params \\ %{}) do
    query =
      User
      |> maybe_filter_by_username(params["username"])
      |> maybe_filter_by_email(params["email"])

    Repo.all(query)
  end

  # Filter by username
  defp maybe_filter_by_username(query, nil), do: query

  defp maybe_filter_by_username(query, username),
    do: from(u in query, where: ilike(u.username, ^"%#{username}%"))

  # Filter by email
  defp maybe_filter_by_email(query, nil), do: query

  defp maybe_filter_by_email(query, email),
    do: from(u in query, where: ilike(u.email, ^"%#{email}%"))

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.

  Returns `nil` if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  Creates a user and a clock for the user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:clock, %Clock{})
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value}, current_user)
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value}, current_user)
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs, current_user \\ nil) do
    user
    |> User.changeset(attrs, current_user)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Generates a token for a user.

  ## Examples

      iex> generate_token(user)
      {:ok, token}

  """
  def generate_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    {:ok, token}
  end

  @doc """
  Authenticates a user.

  ## Examples

      iex> authenticate_user(email, password)
      {:ok, %{user: user, token: token}}

  """
  def authenticate_user(email, password) do
    user = Repo.one(from(u in User, where: u.email == ^email))

    case user do
      nil ->
        Bcrypt.no_user_verify()
        {:error, :unauthorized}

      user ->
        if Bcrypt.verify_pass(password, user.hashed_password) do
          {:ok, token} = generate_token(user)
          {:ok, %{user: user, token: token}}
        else
          {:error, :unauthorized}
        end
    end
  end

  @doc """
  Checks if a user can manage another user.

  ## Examples

      iex> can_manager_user?(manager, user)
      true

  """
  def can_manager_user?(%User{id: user_id1}, %User{id: user_id2}) when user_id1 == user_id2,
    do: true

  def can_manager_user?(%User{role: "admin"}, _), do: true

  def can_manager_user?(manager, user) do
    if Teams.is_user_manager?(manager, user) do
      true
    else
      false
    end
  end

  @doc """
  Checks if a manager can manage another user.

  ## Examples

      iex> manager_can_manager_user?(manager, user)
      true

  """
  def manager_can_manager_user?(%User{role: "admin"}, _), do: true

  def manager_can_manager_user?(manager, user) do
    if Teams.is_user_manager?(manager, user) do
      true
    else
      false
    end
  end

  @doc """
  Checks if a user can manage himself.

  ## Examples

      iex> user_can_manager_user?(manager, user)
      true

  """
  def user_can_manager_user?(%User{id: user_id1}, %User{id: user_id2}) when user_id1 == user_id2,
    do: true

  def user_can_manager_user?(%User{role: "admin"}, _), do: true
  def user_can_manager_user?(_, _), do: false
end
