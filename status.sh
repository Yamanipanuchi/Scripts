#!/bin/bash

source /home/user/status.cfg

NEWLINE=$'\n'

echo    $(date)

function push {
                curl -s -F "token=$token" \
                -F "user=$user" \
                -F "title=$title" \
                -F "message=$1" https://api.pushover.net/1/messages.json \
                -F "priority=0" \
                -F "sound=pushover"
                }

#CuctoHug Forks
forks="Flax HDDCoin StaiCoin Stor BTCGreen Flora Spare Chives Maize Wheat DogeChia Apple Taco Tad Cactus Socks GreenDoge Lucky Shibgreen CryptoDoge Skynet Melati Kale Aedge Mint Mogua Melon Rolls GoldCoin Kujenga PipsCoin Salvia Tranzact Venidium"

for fork in ${forks[@]}

do

lowerfork=`echo $fork | tr '[:upper:]' '[:lower:]'`

if [ "$( docker container inspect -f '{{.State.Status}}' coctohug-${lowerfork[@]} )" == "running" ]; then

        status=`docker exec coctohug-${lowerfork[@]} ${lowerfork[@]} farm summary | grep 'Farming status:' | cut --fields 3 --delimiter=\ | head -n 1 `
        if [ -f "/home/user/state/${lowerfork[@]}.state" ]; then laststatus=`cat /home/user/state/${lowerfork[@]}.state` ; else laststatus=unknown ;fi

        echo $fork: $status - $laststatus

        if [ "$status" != "$laststatus" ]; then

                title="${fork[@]} status change!!"
                alert="${fork[@]} currently $status!"
                        push "$alert" >> /dev/null

                echo $status >/home/user/state/${lowerfork[@]}.state

        fi
fi

done

#Chia
if [ "$( docker container inspect -f '{{.State.Status}}' machinaris )" == "running" ]; then

        status=`docker exec machinaris chia farm summary | grep 'Farming status:' | cut --fields 1 --delimiter=\ | head -n 1 `
        if [ -f "/home/user/state/chia.state" ]; then laststatus=`cat /home/user/state/chia.state` ; else laststatus=unknown ;fi

        echo Chia: $status - $laststatus

        if [ "$status" != "$laststatus" ]; then

                title="$Chia status change!!"
                alert="Chia currently $status!"
                        push "$alert" >> /dev/null

                echo $status >/home/user/state/chia.state

        fi
fi
