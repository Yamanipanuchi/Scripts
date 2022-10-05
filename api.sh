#/bin/bash

sleepSeconds=1
coins="CAC/USDT BPX/USDT CAC/BPX"

for i in ${coins} ; do
        GETCOINS=`curl -s -X POST https://api.vayamos.cc/spot/markets_ex -H 'Content-Type: application/json' -d '{"pair":"'"${i}"'"}'`
        PRICE=`echo ${GETCOINS} | grep price | awk '{print $16}' | sed 's/"//;s/"//;s/,//'`
        HIGH=`echo ${GETCOINS} | grep low | awk '{print $30}' | sed 's/"//;s/"//;s/,//'`
        LOW=`echo ${GETCOINS} | grep low | awk '{print $32}' | sed 's/"//;s/"//;s/,//'`

        GETMARKET=`curl -s -X POST https://api.vayamos.cc/spot/orderbook -H 'Content-Type: application/json' -d '{"pair":"'"${i}"'"}'`

#        GETCOINS=`curl -s -X POST https://api.vayamos.cc/spot/markets -H 'Content-Type: application/json' -d '{"pair":"'"${i}"'"}' | grep price | awk '{print $2}' | sed 's/"//;s/"//;s/,//'`
#        echo ${GETCOINS}
        echo "$i"
        echo $PRICE
        echo $HIGH
        echo $LOW

        echo ${GETMARKET}

        sleep ${sleepSeconds}s
done
