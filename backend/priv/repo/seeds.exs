# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TimeManager.Repo
alias TimeManager.Users.User
alias TimeManager.Clocks.Clock
alias TimeManager.Workingtimes.Workingtime

# Inserting Users
user1 =
  Repo.insert!(%User{
    username: "John Doe",
    email: "john.doe@example.com"
  })

user2 =
  Repo.insert!(%User{
    username: "Jane Smith",
    email: "jane.smith@example.com"
  })

# Inserting Clocks
Repo.insert!(%Clock{
  user_id: user1.id,
  status: true,
  time: ~N[2024-10-08 08:00:00]
})

Repo.insert!(%Clock{
  user_id: user2.id,
  status: false,
  time: ~N[2024-10-08 17:00:00]
})

# Inserting Working Times
Repo.insert!(%Workingtime{
  user_id: user1.id,
  start: ~N[2024-10-08 08:00:00],
  end: ~N[2024-10-08 17:00:00]
})

Repo.insert!(%Workingtime{
  user_id: user2.id,
  start: ~N[2024-10-08 08:00:00],
  end: ~N[2024-10-08 18:00:00]
})
