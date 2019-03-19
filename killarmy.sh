#!/bin/bash
# KILL ALL THE MONKEYS

STOR=/storage

for cattle in $(sudo virsh list --name|grep ^bootmonkey)
do
    echo Murdering $cattle
    sudo virsh destroy $cattle
    sudo virsh undefine $cattle
    sudo rm -f $STOR/${cattle}.qcow2  && echo Domain bootmonkey1 storage removed
done
