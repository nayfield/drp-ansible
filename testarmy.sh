#!/bin/bash

# Run this script on your kvm host.
# Obviously change the values for storage path
# and network name.

# Note: ram=1024 is not big enough to reliably boot el7.
# Hope that saves you an hour of futzing.


num=1
while true
do
	if [ -f /storage/bootmonkey${num}.qcow2 ] ; then
		let num++
	else
		break
	fi
done

echo "Building bootmonkey${num}"

sudo virt-install \
	-n bootmonkey${num} \
	--description "a test boot monkey" \
	--os-type=Linux \
	--os-variant=rhel6 \
	--ram=2048 \
	--vcpus=1 \
	--disk path=/storage/bootmonkey${num}.qcow2,size=10 \
	--network network=privnet \
	--boot network,hd \
	--noautoconsole 
	
