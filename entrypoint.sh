#!/bin/bash

echo "Fixing permissions."
chown steam:steam -R /home/steam/perfectheist2/
ln -s /home/steam/Steam/linux64/steamclient.so /home/steam/.steam/sdk64/steamclient.so

echo "Running srcds_run as steam-user."
ARGS="$@"
su - steam -c "/home/steam/perfectheist2/PerfectHeist2/Binaries/Linux/PerfectHeist2Server $ARGS"

