

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

# $ ansible-playbook -i hosts -t firstrun  -e "ansible_ssh_user=root" -k site.yml -l <hostname>

3. run the whole playbook on everybody

# $ ansible-playbook -i hosts site.yml


## adding more drpservers, now or later
GOTO step 0

## updating drpservers, checking configuration
Do step 3

## I need something to do often, like daily or hourly
Step 3 sounds good

## Why can't I log in to the drpserver anymore?  I have the root password!
Cue Theoden:  You have no power here

## No, seriously ... let me back in!  I need to do my job now that the automation ran!
start making roles in a new branch, and do step #3 ... 

## I'll have to change the way I do my job ... I just wanted to skip all the setup...
That's right.  

Please realize that type of automation - that helps you fast-forward
over a tedious part of your job - has already devalued your job.










