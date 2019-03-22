#!/bin/bash

buildtgt=MYcentos7
disctgt=MYdiscovery


# This could be run 'while true' if you want to play.
# start with a machine in sledgehammer-wait

UUID=$1
drpcli machines exists $UUID || exit 1

myip=$(drpcli machines show $UUID | jq -r '.Address')

echo $(date) starting loop with $UUID $myip

# Wait for it to be at sledgehammer-wait
echo -n $(date) "waiting for discovery to complete: "
drpcli machines wait $UUID Stage sledgehammer-wait 
echo $(date) "reached discovery complete"
ping -c 1 $myip | head -n2

echo $(date) "moving workflow to $buildtgt"
drpcli machines workflow $UUID $buildtgt >/dev/null

echo -n $(date) "waiting for $buildtgt install to complete: "
drpcli machines wait $UUID Stage complete 
echo $(date) "reached $buildtgt complete"

# without a runner on the completed OS this is sorta iffy
#  sleep for 45 seconds to hopefully avoid shutdown time
# as well as early pxe attempts.  bare metal will need
# much longer

stime=45
echo $(date) "sleeping $stime seconds"
sleep $stime
echo $(date) "done sleeping"

echo $(date) "waiting for ping response"
while ! ping -c 1 $myip &>/dev/null ; do :; done
echo $(date) "found pings"

stime=5
echo $(date) "sleeping $stime seconds"
sleep $stime
echo $(date) "done sleeping"

echo $(date) "moving workflow to $disctgt"
drpcli machines workflow $UUID $disctgt >/dev/null

ssh-keygen -R $myip >/dev/null
ssh-keyscan $myip >>~/.ssh/known_hosts 2>/dev/null
ssh root@${myip} reboot

echo $(date) "rebooted host"
