#!/bin/bash

forks="aedge apple avocado btcgreen cactus cannabis chaingreen chia chives covid cryptodoge dogechia ethgreen flax flora fork goji greendoge hddcoin kale lucky maize melati mint mog>

for fork in ${forks[@]}

        do

        if [ "$( docker container inspect -f '{{.State.Status}}' coctohug-$fork )" == "running" ]; then

                status=`docker exec coctohug-${fork[@]} ${fork[@]} wallet show | grep 'Sync status:' | cut --fields 3 --delimiter=\ | head -n 1`
                height=`docker exec coctohug-${fork[@]} ${fork[@]} wallet show | grep 'Wallet height:' | cut --fields 3 --delimiter=\ `
                if [ -f "/home/user/wallet/height.${fork[@]}" ]; then lastheight=`cat /home/user/wallet/height.${fork[@]}`; else lastheight=0; fi
                echo $height >/home/user/wallet/height.${fork[@]}
                change=$(echo "$height - $lastheight" | bc)

                if [ "$( echo -n "$fork" | wc -c)" -lt 7 ]; then
                        echo $fork $'\t\t' $status $'-' ${height} $'+' $change
                        else
                        echo $fork $'\t' $status $'-' ${height} $'+' $change
                fi
                else
                if [ "$( echo -n "$fork" | wc -c)" -lt 7 ]; then
                        if [ -f "/home/user/wallet/height.${fork[@]}" ]; then lastheight=`cat /home/user/wallet/height.${fork[@]}`; else lastheight=0; fi
                        echo $fork $'\t\t' Offline - $lastheight
                        else
                        echo $fork $'\t' Offline - $lastheight
                fi
        fi
done
