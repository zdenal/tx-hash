#!/bin/bash

cd apps/tx_hash
mix ecto.setup

cd ../api
mix ecto.setup
mix phx.server
