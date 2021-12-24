#!/bin/bash

forks="flax hddcoin staicoin stor aedge flora btcgreen chives spare maize wheat apple dogechia tad taco socks greendoge mint mogua lucky chaingreen cryptodoge shibgreen cactus"

for fork in ${forks[@]}

do
        if [ "$( docker container inspect -f '{{.State.Status}}' coctohug-$fork )" == "exited" ]; then

                echo "Starting $fork"
                docker start coctohug-${fork[@]}
                sleep 60

                until [ "$( awk '{print $2}' /proc/loadavg | cut -d. -f1 )" -lt 6 ]; do

                        echo "Waiting for CPU to calm down"
                        sleep 10

                done

                else

                echo "$fork = Already Running"

        fi


done
