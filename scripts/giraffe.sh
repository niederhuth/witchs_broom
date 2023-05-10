#!/bin/bash --login
#SBATCH --time=168:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=60GB
#SBATCH --job-name giraffe
#SBATCH --output=%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda="${HOME}/miniconda3"

#Set variables
threads=20

#Change to current directory
cd ${PBS_O_WORKDIR}
#Export paths to conda
export PATH="${conda}/envs/pangenome/bin:$PATH"
export LD_LIBRARY_PATH="${conda}/envs/pangenome/lib:$LD_LIBRARY_PATH"

#
vg giraffe \
	-t ${threads} \
	-Z index.giraffe.gbz \
	-f Dakopa_Wild_Type_S3_L002_R1_001.cutadapt.fq.gz \
	-f Dakopa_Wild_Type_S3_L002_R2_001.cutadapt.fq.gz > test.gam


