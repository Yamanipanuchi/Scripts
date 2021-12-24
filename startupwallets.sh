#!/bin/bash

forks="flax hddcoin staicoin stor btcgreen aedge flora spare chives maize wheat dogechia apple taco tad goji socks greendoge mint mogua lucky chaingreen shibgreen cryptodogeavocado >

for fork in ${forks[@]}

do
        if [ "$( docker container inspect -f '{{.State.Status}}' coctohug-$fork )" == "exited" ]; then

                until [ "$( awk '{print $2}' /proc/loadavg | cut -d. -f1 )" -lt 4 ]; do 
                        echo "Waiting for CPU to calm down"
                        sleep 10
                done

                echo "Starting $fork"
                docker start coctohug-${fork[@]}
                sleep 60

                else

                echo "$fork = Already Running"

        fi


done
