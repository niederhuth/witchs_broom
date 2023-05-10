#!/bin/bash --login
#SBATCH --time=168:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=60GB
#SBATCH --job-name giraffe
#SBATCH --output=job_reports/%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda="${HOME}/miniconda3"

#Set variables
threads=20
PE="TRUE"
index="$(pwd | sed s/Vvinifera.*/Vvinifera/)/pangenome/giraffe/index.giraffe.gbz"
datatype="wgs"

#Change to current directory
cd ${PBS_O_WORKDIR}
#Export paths to conda
export PATH="${conda}/envs/pangenome/bin:$PATH"
export LD_LIBRARY_PATH="${conda}/envs/pangenome/lib:$LD_LIBRARY_PATH"

#Make output directory
if [[ ! -d giraffe ]]
then
	mkdir giraffe
fi

#Set arguments
arguments="-t ${threads} -Z ${index}"

#Set input fastq
if [ ${PE} = "TRUE" ]
then
	arguments="${arguments} -f fastq/${datatype}/trimmed.1.fastq.gz -f fastq/${datatype}/trimmed.2.fastq.gz"
else
	arguments="${arguments} -f trimmed.1.fastq.gz"
fi

#Run giraffe
echo "Running giraffe"
vg giraffe ${arguments} > giraffe/aln.gam

echo "Done"
