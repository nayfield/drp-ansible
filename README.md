

This playbook makes digital rebar provision servers


## Pre work

* Put a ssh public key in secrets/pubkey.for.drpuser
* This should be a key your ansible user is configured to try


##  Requirements on your drp servers

* Not much: a bare-bones install and the root password
* preferrably a machine nobody has logged into
* Tested against 'minimal' install of RHEL7.


## Adding your first drp server(s)
0. ssh to nosuchuser@<hostname> to save the host key, then ctrl-c
1. add the hostname to the drpservers section in hosts
2. for each host added, run the 'firstrun' tag (use the root password)

```
 $ ansible-playbook t firstrun -e "ansible_ssh_user=root" -k site.yml -l <hostname>
```

3. run the whole playbook on everybody

```
 $ ansible-playbook site.yml
```

## What do I need to change?
1. Your network definitions.  And decide how you are going to run this ... 

 * once they're built, depend on this to be running and have the uuid in complete state so it doesn't boot to sledgehammer?
 * create a task in the complete stage to turn off pxeboot ... or at least have pxe after disk (only if disk is not bootable)
 * build subnets out completely and remove dhcp helper that points here?
 * something else?  or combination of above?

2. Your own OS images, integrated with kickstarts and pushing into your post-buildout workflows ... 

3. more fancy ipmi tasks and stages

4. why not do something useful instead of sledgehammer-wait if you've got the machines powered on?  

## Sorta faq

### adding more drpservers, now or later
GOTO step 0

### updating drpservers, checking configuration
Do step 3

### I need something to do often, like daily or hourly
Step 3 sounds good

### Why can't I log in to the drpserver anymore?  I have the root password!
![You have no power here](https://i.kym-cdn.com/photos/images/original/000/913/758/a12.jpg :You have no power here")

### No, seriously ... let me back in!  I need to do my job now that the automation ran!
start making roles in a new branch, and do step #3 ... 

### what about testing stuff
1. Make some vms (on your kvm host)

```
$ for i in $(seq 1 9); do ./testarmy.sh ; done
```

2. Wait a bit until they boot and register - then start building (on your drp server)
```
$ sleep 180 && dodrp list
$ dodrp buildall
```

3. There is no step three.  But if you want to clean stuff up:

On your host:
```
$ for i in $(seq 1 10); do sudo virsh destroy bootmonkey${i} ; done
$ for i in $(seq 1 10); do sudo virsh undefine bootmonkey${i} ; done
$ for i in $(seq 1 10); do sudo rm -f /storage/bootmonkey${i}.qcow2 ; done
```

And on your drp server:
```
$ dodrp deleteall
```









