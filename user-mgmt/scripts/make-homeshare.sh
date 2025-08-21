#!/bin/bash

# usage make-homeshare.sh $user

set -e      # stop on error
set -u      # stop on uninitialized variable

user=$1
export user

# create cephfs home directory and permissions
echo "START: Creating CephFS home directory and quota for $user"

slurmlogin=`kubectl -n slurm get pod --selector networkservice=slurmlogin --field-selector status.phase==Running -o "jsonpath={.items[0].metadata.name}"`
echo "Using $slurmlogin as slurmlogin"

echo "Copying skel and creating $user home directory"
kubectl -n slurm exec -it $slurmlogin -- cp -R /etc/skel /home/"$user"
sleep 1
echo "...done!"

echo "Setting chmod 770 for $user home directory"
kubectl -n slurm exec -it $slurmlogin -- chmod -R 770 /home/"$user"
sleep 1
echo "...done!"

echo "Setting chown for $user home directory"
kubectl -n slurm exec -it $slurmlogin -- chown -R "$user":"$user" /home/"$user"

echo "...done!"

echo "Setting 25GiB quota for $user home directory"

kubectl -n slurm exec -it $slurmlogin -- setfattr -n ceph.quota.max_bytes -v 26843545600 /home/"$user"

echo "...done!"

echo "SUCCESS: $user home directory and quota created"
echo "Results:"

kubectl -n slurm exec -it $slurmlogin -- ls -alth /home/ | grep $user
sleep 1
kubectl -n slurm exec -it $slurmlogin -- getfattr -n ceph.quota.max_bytes home/"$user"
