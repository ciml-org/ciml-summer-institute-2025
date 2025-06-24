#!/usr/bin/env bash

#SBATCH --job-name=hvd-tf2-train-cnn-cifar-gpu
#SBATCH --account=gue998
#SBATCH --reservation=ciml25gpu
#SBATCH --partition=gpu
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=368G
#SBATCH --gpus=4
#SBATCH --time=00:10:00
#SBATCH --output=%x.o%j.%N

declare -xr LUSTRE_PROJECT_DIR="/expanse/lustre/projects/${SLURM_ACCOUNT}/${USER}"
declare -xr LUSTRE_SCRATCH_DIR="/expanse/lustre/scratch/mkandes/temp_project"
declare -xr LOCAL_SCRATCH_DIR="/scratch/${USER}/job_${SLURM_JOB_ID}"

declare -xr SCHEDULER_MODULE='slurm/expanse/23.02.7'
declare -xr SOFTWARE_MODULE='gpu/0.17.3b'
declare -xr COMPILER_MODULE='gcc/10.2.0'
declare -xr MPI_MODULE='openmpi/4.1.3'

declare -xr SINGULARITY_MODULE='singularitypro/3.11'
declare -xr SINGULARITY_CONTAINER_DIR='/cm/shared/apps/containers/singularity'

module purge
module load "${SCHEDULER_MODULE}"
module load "${SOFTWARE_MODULE}"
module load "${COMPILER_MODULE}"
module load "${MPI_MODULE}"
module load "${SINGULARITY_MODULE}"
module list
export OMPI_MCA_btl='self,vader'
export UCX_TLS='shm,rc,ud,dc'
export UCX_NET_DEVICES='mlx5_0:1'
export UCX_MAX_RNDV_RAILS=1
export KERAS_HOME="${LOCAL_SCRATCH_DIR}"
printenv

time -p mpirun -n "${SLURM_NTASKS}" singularity exec --bind "${KERAS_HOME}:/tmp,/expanse,/scratch" --nv "${SINGULARITY_CONTAINER_DIR}/tensorflow/tensorflow_2.15.1-openmpi-4.1.6-mofed-5.8-2.0.3.0-cuda-12.1.1-ubuntu-22.04.4-x86_64-20240316.sif" python3 -u hvd-tf2-train-cnn-cifar.py
