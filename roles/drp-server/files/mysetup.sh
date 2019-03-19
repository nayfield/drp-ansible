#!/bin/bash

# decided this needs to be scripted.  much better to show how the api would work.

drpcli=/app/PXE/drp-bin/drpcli


# First - ISOs.
# drpcli isos list - what I have
# isos are objects resulting from bootenvs.  drpcli bootenvs uploadisos gets them
iwant="sledgehammer centos-7-install"


ihave=$($drpcli isos list | jq '.[]' )
for bootenv in $iwant
do
    echo "Checking bootenv $bootenv"
    for need in $($drpcli bootenvs show $bootenv | jq '.OS.SupportedArchitectures|.[].IsoFile')
    do
        echo " Checking $need"
        grep -q $need <<<$ihave && continue
        echo needed
        $drpcli bootenvs uploadiso $bootenv
    done
done


# This is a stage
stage=centos-7-install-nor
if $drpcli stages exists $stage
then
    echo Stage centos exists
else
    cat ~/MYsetup/nor | $drpcli stages create - >/dev/null
fi

# Workflows
if $drpcli workflows exists MYdiscovery
then
    echo workflow discovery exists
else
    $drpcli workflows create '{ "Name": "MYdiscovery", "Stages": [ "discover", "sledgehammer-wait" ] } ' >/dev/null
fi

# Workflows
if $drpcli workflows exists MYcentos7
then
    echo workflow centos exists
else
    $drpcli workflows create '{ "Name": "MYcentos7", "Stages": [ "centos-7-install-nor", "complete" ] } ' > /dev/null
fi


# networks
if $drpcli subnets exists privnet
then
    echo subnet privnet exists
else
    cat ~/MYsetup/networks.json | $drpcli subnets create - >/dev/null
fi


# These just override so we don't check
cat ~/MYsetup/sshkey.json | $drpcli profiles update global - >/dev/null
$drpcli prefs set defaultWorkflow MYdiscovery unknownBootEnv discovery defaultBootEnv sledgehammer defaultStage discover

exit 0
