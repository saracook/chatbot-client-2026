#!/bin/bash
USER_SUNET=$1
ACM_ROOT=~/srcc-anthos-acm-config-repo

#copy template
cp -r $ACM_ROOT/scripts/templates/cluster $ACM_ROOT/cluster/$USER_SUNET
cp -r $ACM_ROOT/scripts/templates/namespaces/ $ACM_ROOT/namespaces/$USER_SUNET

#replace with user sunet for the cluster
cd $ACM_ROOT/cluster/$USER_SUNET/pv
sed -i.bak s/REPLACEME/$USER_SUNET/g *
rm *.bak
#rename files to $USER_SUNET
for i in `ls *-REPLACEME.yaml`; do
	mv $i `echo $i | sed s/REPLACEME/$USER_SUNET/g`
done

#replace with user sunet for the namepace
cd $ACM_ROOT/namespaces/$USER_SUNET/
sed -i.bak s/REPLACEME/$USER_SUNET/g *
rm *.bak
#copy slurm and user stuff
cp $ACM_ROOT/namespaces/slurm/extrausers.yaml .
cp $ACM_ROOT/namespaces/slurm/munge-key.yaml .
cp $ACM_ROOT/namespaces/slurm/slurm-node-conf.yaml .
