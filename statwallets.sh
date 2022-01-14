#!/bin/bash

source /home/user/wallet.cfg
sleep 1
NEWLINE=$'\n'

echo    $(date) >/home/user/SyncStat.txt

for fork in ${forks[@]} ; do

        lowerfork=`echo $fork | tr '[:upper:]' '[:lower:]'`
        lastheight=0
        lastbalance=0
        balance=0

        if [ "$( docker container inspect -f '{{.State.Status}}' coctohug-$lowerfork )" == "running" ]; then

                if [ "$( cat /home/user/wallet/${lowerfork[@]}.cap | grep 'Connection' | cut --fields 1 --delimiter=\ )" != "Connection" ]; then
                        status=`cat /home/user/wallet/${lowerfork[@]}.cap | grep 'Sync status:' | cut --fields 3 --delimiter=\ | head -n 2`
                        height=`cat /home/user/wallet/${lowerfork[@]}.cap | grep 'Wallet height:' | cut --fields 3 --delimiter=\ `
                        balance=`cat /home/user/wallet/${lowerfork[@]}.cap | grep '.Total Balance:' | cut --fields 6 --delimiter=\ | head -n 1`
                else
                        if [ -f "/home/user/wallet/$fork.info" ]; then source /home/user/wallet/$fork.info ; fi
                fi
                if [ -f "/home/user/wallet/${fork[@]}.info" ]; then source /home/user/wallet/${fork[@]}.info ; fi
                if [ "$height" != "" ]; then echo lastheight=$height >/home/user/wallet/${fork[@]}.info ; fi
                if [ "$balance" != "" ]; then echo lastbalance=$balance >>/home/user/wallet/${fork[@]}.info ; fi
                change=$(echo "$height - $lastheight" | bc)

#               if [ "$status" == "Synced" ]; then docker stop coctohug-$fork >/dev/null ; fi

                if [ "$change" == "0" ]; then 
                        docker stop coctohug-$lowerfork >/dev/null
                        sleep 5
                        docker start coctohug-$lowerfork >/dev/null
                fi



                if [ "$( echo -n "$fork" | wc -c)" -lt 7 ]; then
                        echo $fork $'\t\t'${balance:0:7}$'\t' $status $'-' ${height} $'+' $change >>/home/user/SyncStat.txt
                        echo $fork $'\t\t'${balance:0:7}$'\t' $status $'-' ${height} $'+' $change
                        else
                        echo $fork $'\t'${balance:0:7}$'\t' $status $'-' ${height} $'+' $change >>/home/user/SyncStat.txt
                        echo $fork $'\t'${balance:0:7}$'\t' $status $'-' ${height} $'+' $change
                fi

                else

                if [ -f "/home/user/wallet/$fork.info" ]; then source /home/user/wallet/$fork.info ; fi

                if [ "$( echo -n "$fork" | wc -c)" -lt 7 ]; then
                        echo $fork $'\t\t'${lastbalance:0:7}$'\t' Offline - $lastheight >>/home/user/SyncStat.txt
                        echo $fork $'\t\t'${lastbalance:0:7}$'\t' Offline - $lastheight
                        else
                        echo $fork $'\t'${lastbalance:0:7}$'\t' Offline - $lastheight >>/home/user/SyncStat.txt
                        echo $fork $'\t'${lastbalance:0:7}$'\t' Offline - $lastheight
                fi
        fi
done
