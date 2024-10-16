#!/bin/sh

# Migrate the database
mix ecto.create
mix ecto.migrate

# Start the phoenix server
exec mix phx.server