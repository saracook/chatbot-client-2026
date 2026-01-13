---
title: "Slurm on Carina"
permalink: /slurm-carina
folder: "using-carina"
seealso: true
toc: true
---
Carina has three Slurm queues. Choose your queue based on how much time you need. All three queues run on the same hardware.

### Slurm Queues/Partitions

Queues and Partitions are the same thing and the terms are used interchangeably. 

#### dev

The `dev` partition is for active development; there is a two-hour time limit, which keeps the resources available and wait times short. 

#### normal

The `normal` partition is for running your jobs. The time limit is two days. Your jobs may sit in the queue waiting for resources.

#### long

Jobs in `long` need more than two days, and can run up to five days. 

### GPUs

GPUs can be requested on any of the partitions. For example, including this in an sbatch script will request 1 gpu.

`#SBATCH --gres=gpu:1`
