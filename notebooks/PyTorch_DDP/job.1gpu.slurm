#!/bin/bash
#SBATCH --job-name=mnist-ddp
#SBATCH --gpus-per-task 1  # This gives 1 GPU to each process (or task)
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1# The number of processes for slurm to start on each node
#SBATCH -c 1
#SBATCH --reservation=jhlsrf016_batch_jobs
#SBATCH -p gpu_titanrtx_shared_course
#SBATCH --time=00:04:00
#SBATCH --mem=16G

export MASTER_PORT=$(expr 10000 + $(echo -n $SLURM_JOBID | tail -c 4))
export WORLD_SIZE=$(($SLURM_NNODES * $SLURM_NTASKS_PER_NODE))
echo "WORLD_SIZE="$WORLD_SIZE

master_addr=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_ADDR=$master_addr
echo "MASTER_ADDR="$MASTER_ADDR

srun python mnist_classify_ddp.py --batch-size 128 --epochs 1
