FROM bitwalker/alpine-elixir-phoenix:latest

#COPY mix.exs /txhash/mix.exs
#COPY mix.lock /txhash/mix.exs

WORKDIR /txhash/

ADD ./ /txhash/

COPY ./apps/tx_hash/config/dev.exs.docker /txhash/apps/tx_hash/config/dev.exs
COPY ./apps/tx_hash/config/test.exs.docker /txhash/apps/tx_hash/config/test.exs

COPY ./apps/api/config/dev.exs.docker /txhash/apps/api/config/dev.exs
COPY ./apps/api/config/test.exs.docker /txhash/apps/api/config/test.exs
RUN mix deps.get
#RUN mix deps.compile

#WORKDIR /txhash/apps/tx_hash
#RUN mix ecto.setup

#WORKDIR /txhash/apps/api
#RUN mix ecto.setup

#CMD ["mix", "phx.server"]
