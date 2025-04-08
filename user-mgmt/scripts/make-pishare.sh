#!/bin/bash

# usage make-pishare.sh $user

set -e      # stop on error
set -u      # stop on uninitialized variable

user="$1"
export user

echo "START: Creating CephFS pi directory and quota for $user"

slurmlogin=`kubectl -n slurm get pod --selector networkservice=slurmlogin --field-selector status.phase==Running -o "jsonpath={.items[0].metadata.name}"`
echo "Using $slurmlogin as slurmlogin"

echo "Creating $user pi directory"
kubectl -n slurm exec -it $slurmlogin -- mkdir /share/pi/"$user"
sleep 1
echo "...done!"

echo "Setting chmod 3770 for $user pi directory"
kubectl -n slurm exec -it $slurmlogin -- chmod -R 3770 /share/pi/"$user"
sleep 1
echo "...done!"

echo "Setting chown for $user pi directory"
kubectl -n slurm exec -it $slurmlogin -- chown -R "$user":"$user"-pi /share/pi/"$user"
echo "...done!"

# TODO: not working at the moment, set from mon-b15-19
#echo "Setting 1TB quota for $user pi directory"
#kubectl -n slurm exec -it $slurmlogin -- setfattr -n ceph.quota.max_bytes -v 1099511992568 /share/pi/"$user"

echo "SUCCESS: $user pi directory created"
echo "Results:"
kubectl -n slurm exec -it $slurmlogin -- ls -alth /share/pi/ | grep $user
echo "--------------------------------------"
echo "Please set a 1TB quota from mon-b15-19:"
echo "sudo setfattr -n ceph.quota.max_bytes -v 1099511992568 /mnt/pi/8a38c8df-cfcd-4d8c-bee5-ad121dcc50b3/pi/$user"
echo "--------------------------------------"
