#!/usr/bin/env bash

if [ "$#" -eq "0" ]; then
    echo "Usage: $0 <name_of_lunaci_container>" > /dev/stderr
    exit 1
fi

docker run --env-file env.list -v $PWD/data:/home/lunaci/data -v $PWD/logs:/home/lunaci/logs  $1
