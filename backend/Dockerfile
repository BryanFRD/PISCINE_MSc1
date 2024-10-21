FROM elixir:1.17.3-alpine

COPY . /app

WORKDIR /app

ENV MIX_ENV=prod

RUN mix deps.get --only prod
RUN MIX_ENV=prod mix compile

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["mix", "phx.server"]