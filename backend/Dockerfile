FROM elixir:1.17.3

COPY . /app

WORKDIR /app

ENV MIX_ENV=prod

RUN mix deps.get --only prod
RUN MIX_ENV=prod mix compile

CMD ["mix", "phx.server"]