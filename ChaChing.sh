#!/bin/bash

source /home/user/ChaChing.cfg

NEWLINE=$'\n'

echo    $(date)

function push {
                curl -s -F "token=$token" \
                -F "user=$user" \
                -F "title=$title" \
                -F "message=$1" https://api.pushover.net/1/messages.json \
                -F "priority=0" \
                -F "sound=cashregister"
                }

#CuctoHug Forks
forks="Chia Flax HDDCoin StaiCoin Stor BTCGreen Flora Spare Chives Maize Wheat DogeChia Apple Taco Tad Cactus Socks GreenDoge Lucky Shibgreen CryptoDoge Skynet Melati Kale Aedge Mint Mogua Melon Rolls GoldCoin Kujenga PipsCoin Salvia Tranzact Venidium"

for fork in ${forks[@]}

do

lowerfork=`echo $fork | tr '[:upper:]' '[:lower:]'`

if [ "$( docker container inspect -f '{{.State.Status}}' coctohug-${lowerfork[@]} )" == "running" ]; then

        rm /tmp/wallet.cap
        docker exec coctohug-${lowerfork[@]} ${lowerfork[@]} wallet show > /tmp/wallet.cap
        test=`cat /tmp/wallet.cap | grep 'Wallet' | cut --fields 1 --delimiter=\ | head -n 1 `
#       echo $test
        if [ "$test" == "Wallet" ]; then cp /tmp/wallet.cap /home/user/wallet/${lowerfork[@]}.cap ; fi

        bal=`cat /home/user/wallet/${lowerfork[@]}.cap | grep '   .Total Balance:' | cut --fields 6 --delimiter=\ | head -n 1`

        if [ -f "/home/user/wallet/${lowerfork[@]}.bal" ]; then lastbal=`cat /home/user/wallet/${lowerfork[@]}.bal` ; else lastbal=0.0 ;fi

        echo "Fork: $fork - $bal - $lastbal"

        if [ "$bal" != "$lastbal" ]; then

                change=$(echo "$bal - $lastbal" | bc)
                title="${fork[@]} balance change!"
                alert="Balance changed by $change ${NEWLINE}New balance = ${bal}"
                        push "$alert" >> /dev/null

                echo $bal >/home/user/wallet/${lowerfork[@]}.bal

        fi
fi
