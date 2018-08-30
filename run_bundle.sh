#!/bin/bash

dir=$(pwd)

cd $dir/txhash-fe
docker-compose up -d

cd $dir/txhash
docker-compose up -d
