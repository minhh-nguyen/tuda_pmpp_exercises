#!/bin/bash

# SLURM parameters
#SBATCH -n 1
#SBATCH -t 5
#SBATCH --mem-per-cpu 3800
#SBATCH --gpus-per-task=1

# Special parameters. DO NOT CHANGE THESE!
#SBATCH -A kurs00108
#SBATCH -p kurs00108
#SBATCH --reservation=kurs00108

# Redirect stdout and stderr
#SBATCH -o ex1.out
#SBATCH -e ex1.err

module purge
module load cuda/12.9 gcc/13.4
mkdir -p out
./build/pmpp_ex1
