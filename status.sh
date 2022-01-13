#!/bin/bash

source /home/user/status.cfg

maxmem=2048
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
forks="Aedge Apple BTCGreen Cactus Chives Cryptodoge Dogechia Flax Flax Goldcoin Greendoge HDDcoin Kale Kujenga Lucky Maize Melon Mint Mogua Pipscoin Rolls Salvia Shibgreen Skynet Socks Spare Staicoin Stor Taco Tad Tranzact Venidium Wheat"
#forks="Flax HDDCoin StaiCoin Stor BTCGreen Flora Spare Chives Maize Wheat DogeChia Apple Taco Tad Cactus Socks GreenDoge Lucky Shibgreen CryptoDoge Skynet Kale Aedge Mint Melon Rolls GoldCoin PipsCoin Salvia Tranzact Venidium"
memcap=`docker stats --no-stream `

for fork in ${forks[@]}

do

        lowerfork=`echo $fork | tr '[:upper:]' '[:lower:]'`
        echo "Checking fork $fork"
        if [ "$( docker container inspect -f '{{.State.Status}}' coctohug-${lowerfork[@]} )" == "running" ]; then
                status=`docker exec coctohug-${lowerfork[@]} ${lowerfork[@]} farm summary | grep 'Farming status:' | cut --fields 3-4 --delimiter=\ | head -n 3 `
                memusage=`echo "$memcap" | grep coctohug-${lowerfork[@]} | awk '{ if(index($4, "GiB")) {gsub("GiB","",$4); print $4 * 1000} else {gsub("MiB","",$4); print $4}}' `

                echo "$fork - $memusage"

                if [ $memusage -gt $maxmem ]; then
                        echo "*** Restart $fork due to memory usage"
                        docker stop coctohug-$lowerfork >/dev/null
                        sleep 5
                        docker start coctohug-$lowerfork >/dev/null

                                title="${fork[@]} restarting!!"
                                alert="${fork[@]} restarting due to memory usage!"
                                        push "$alert" >> /dev/null


                else

                        if [ -f "/home/user/state/${lowerfork[@]}.state" ]; then laststatus=`cat /home/user/state/${lowerfork[@]}.state` ; else laststatus=unknown ;fi

                        echo "$fork: $status - $laststatus"

                        if [ "$status" != "$laststatus" ]; then

                                title="${fork[@]} status change!!"
                                alert="${fork[@]} currently $status!"
                                        push "$alert" >> /dev/null

                                echo $status >/home/user/state/${lowerfork[@]}.state
                         fi
                fi
        fi

done

#Chia
if [ "$( docker container inspect -f '{{.State.Status}}' machinaris )" == "running" ]; then

        status=`docker exec machinaris chia farm summary | grep 'Farming status:' | cut --fields 1 --delimiter=\ | head -n 1 `
        if [ -f "/home/user/state/chia.state" ]; then laststatus=`cat /home/user/state/chia.state` ; else laststatus=unknown ;fi

        echo "Chia: $status - $laststatus"

        if [ "$status" != "$laststatus" ]; then

                title="$Chia status change!!"
                alert="Chia currently $status!"
                        push "$alert" >> /dev/null

                echo $status >/home/user/state/chia.state

        fi
fi
