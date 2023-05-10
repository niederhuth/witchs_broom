#!/bin/bash --login
#SBATCH --time=168:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=60GB
#SBATCH --job-name call_variants
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
# Compute the read support from the gam
# -Q 5: ignore mapping and base qualitiy < 5
# -s 5: ignore first and last 5bp from each read
vg pack \
	-t ${threads} \
	-x index.giraffe.gbz \
	 -g test.gam \
	-Q 5 \
	-s 5 \
	-o aln.pack \
	-d > node_coverage.tsv

