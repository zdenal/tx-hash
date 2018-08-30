#!/bin/bash

cd apps/tx_hash
mix ecto.setup
mix test

cd ../tx_checker
mix test

cd ../api
mix ecto.setup
mix test
