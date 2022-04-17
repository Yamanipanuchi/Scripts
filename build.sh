#!/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
if [ ! -d "$SCRIPTPATH/compose/$1" ]; then mkdir $SCRIPTPATH/compose/$1 ; fi
echo "version: '3.7'" > $SCRIPTPATH/compose/$1/docker-compose.yml
echo "services:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "  coctohug-$1:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "    image: raingggg/coctohug-$1:develop" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "    container_name: coctohug-$1" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "    deploy:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      resources:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "        limits:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "          cpus: '6'" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "    networks:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - coctohug-network" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "    volumes:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - /mnt/db/coctohug:/root/.coctohug" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - /mnt/db/coctohug-$1:/root/.chia" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - /mnt/drives:/drives" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "    environment:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - TZ=America/Los_Angeles" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - mode=fullnode" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - controller_address=192.168.1.20" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - worker_address=192.168.1.20" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - plots_dir=/drives/plots01:/drives/plots02:/drives/plots03:/drives/plots04:/drives/plots05:/drives/plots06:/drives/plots07:/drives/plots08:/drives/plots09:/drives/plots10:/drives/plots11" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "    ports:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - 12655:12655" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - 26666:26666" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - 26667:26667" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "      - MAX_PEER_COUNT=6" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "networks:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "  coctohug-network:" >> $SCRIPTPATH/compose/$1/docker-compose.yml
echo "    name: coctohug-app-network" >> $SCRIPTPATH/compose/$1/docker-compose.yml
