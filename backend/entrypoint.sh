#!/bin/sh

# Migrate the database
mix ecto.setup

# Start the phoenix server
exec mix phx.server