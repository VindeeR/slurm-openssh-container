#!/bin/bash
# Docker entrypoint of the docker image of the slurm and openssh docker container 
#
# Copyright (C) 2025  Manuel G. Marciani
# BSC-CNS - Earth Sciences

cat <<EOF > /etc/slurm/cgroup.conf
###
# Slurm cgroup support configuration file.
# https://slurm.schedmd.com/cgroup.conf.html
###
ConstrainCores=yes
ConstrainDevices=yes
ConstrainRAMSpace=yes
ConstrainSwapSpace=yes
IgnoreSystemd=yes
EnableControllers=yes
EOF

dbus-daemon --system --syslog --print-pid --print-address --fork
sleep 1

/usr/bin/mysqld_safe &
# TODO uncrappyfy this 
sleep 1
/usr/sbin/sshd & 
/usr/sbin/slurmdbd & 
sleep 1
/usr/sbin/slurmd -N slurmctld &
/usr/sbin/slurmctld -Dvvv
