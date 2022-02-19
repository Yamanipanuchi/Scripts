#!/bin/bash

sitwallet=sit1rf5dhquznnfxlgxnjz7ynvp550c0lluf9vvagsj2tjzls53guezqa3uwa7
goldwallet=gl1rf5dhquznnfxlgxnjz7ynvp550c0lluf9vvagsj2tjzls53guezq0s2mk6

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
