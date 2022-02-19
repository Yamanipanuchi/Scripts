#!/bin/bash

sitwallet=
goldwallet=

if [ "$( docker container inspect -f '{{.State.Status}}' coctohug-silicoin )" == "running" ]; then

        echo "Silicoin: Getting balance"
        balance=`docker exec coctohug-silicoin sit wallet show | grep 'Spendable:' | cut --fields 5 --delimiter=' ' `
        echo "Silicoin: $balance"
        if [ "$balance" != "0.0" ]; then
        echo "Staking $balance"
        docker exec coctohug-silicoin sit wallet send -a $balance -t $sitwallet
        fi

else
        running=false
        echo "Silicoin: Docker not running"
fi

if [ "$( docker container inspect -f '{{.State.Status}}' coctohug-gold )" == "running" ]; then

        echo "Gold: Getting balance"
        balance=`docker exec coctohug-gold chia wallet show | grep 'Spendable:' | cut --fields 5 --delimiter=' ' `
        echo "Gold: $balance"
        if [ "$balance" != "0.0" ]; then
        echo "Staking $balance"
        docker exec coctohug-gold chia wallet send -a $balance -t $goldwallet
        fi

else
        running=false
        echo "Gold: Docker not running"      
fi
