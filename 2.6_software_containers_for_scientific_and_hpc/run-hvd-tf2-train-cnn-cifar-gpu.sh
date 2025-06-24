#!/usr/bin/env bash

#SBATCH --job-name=hvd-tf2-train-cnn-cifar-gpu
#SBATCH --account=sds184
#SBATCH --reservation=ciml2022gpu
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

declare -xr SCHEDULER_MODULE='slurm/expanse/21.08.8'
declare -xr SOFTWARE_MODULE='gpu/0.15.4'
declare -xr CUDA_MODULE='cuda/11.0.2'
declare -xr MPI_MODULE='openmpi/4.0.4'

declare -xr SINGULARITY_MODULE='singularitypro/3.9'
declare -xr SINGULARITY_CONTAINER_DIR="${LUSTRE_SCRATCH_DIR}"

module purge
module load "${SCHEDULER_MODULE}"
module load "${SOFTWARE_MODULE}"
module load "${CUDA_MODULE}"
module load "${MPI_MODULE}"
module load "${SINGULARITY_MODULE}"
module list
export OMPI_MCA_btl='self,vader,openib'
export OMPI_MCA_btl_openib_if_include='mlx5_0:1'
export OMPI_MCA_btl_openib_allow_ib='true'
printenv

time -p mpirun -n "${SLURM_NTASKS}" singularity exec --nv "${SINGULARITY_CONTAINER_DIR}/tensorflow-2.8.2-ubuntu-20.04-cuda-11.2-mlnx-ofed-4.9-4.1.7.0-openmpi-4.1.3.sif" python3 -u hvd-tf2-train-cnn-cifar.py
