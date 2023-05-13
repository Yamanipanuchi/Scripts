#!/bin/bash

output=$(docker exec machinaris-$1 $1 show -s)
if echo "$output" | grep -q "Not Synced"; then
    echo "Not synced"
    nodes=$(wget -qO- "https://api.alltheblocks.net/$1/peer/recent/sh?amount=20&excludeV4=false&excludeV6=true&random=false")
    while read -r command; do
        eval "docker exec machinaris-$1 $command"

    done <<< "${nodes}"

fi
echo "Done"
