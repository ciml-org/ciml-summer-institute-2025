# Session 2.6 Software Containers for Scientific and High-Performance Computing

**Date:** Tuesday, June 24, 2025

**Summary**: Singularity is an open-source container engine designed to bring operating system-level virtualization to scientific and high-performance computing. With Singularity you can package complex computational workflows --- software applications, libraries, and data --- in a simple, portable, and reproducible way, which can then be run almost anywhere. 

**Presented by:** [Marty Kandes](https://www.linkedin.com/in/marty-kandes-b53a34144/) (mkandes  @sdsc.edu ) 

### Reading and Presentations:
* **Lecture material:**
* **Source Code/Examples:**

Download a container from a Docker registry.

```
srun-compute
```
```
export SINGULARITY_CACHEDIR="/scratch/$USER/job_$SLURM_JOB_ID"
```
```
[etrain102@exp-2-41 ~]$ module load singularitypro
[etrain102@exp-2-41 ~]$ module list

Currently Loaded Modules:
  1) shared   2) cpu/0.17.3b (c)   3) slurm/expanse/23.02.7   4) sdsc/1.0   5) DefaultModules   6) singularitypro/3.11

  Where:
   c:  built natively for AMD Rome

 

[etrain102@exp-2-41 ~]$
```
```
singularity build scipy-notebook.sif docker://quay.io/jupyter/scipy-notebook:latest
```

[Back to Top](#top)
