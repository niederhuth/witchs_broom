#!/bin/bash --login
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=60GB
#SBATCH --job-name index
#SBATCH --output=%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda="${HOME}/miniconda3"

#Set variables
threads=20
worflow="map" #map, mpmap, rpvg, giraffe
ref_fasta="$(pwd | sed s/pangenome//)/Vvinifera/ref/Vvinifera.fa"
vcf="vcf/Dakapo.var.filtered.vcf.gz vcf/Merlot.var.filtered.vcf.gz"
tmp_dir=

#Change to current directory
cd ${PBS_O_WORKDIR}
#Export paths to conda
export PATH="${conda}/envs/pangenome/bin:$PATH"
export LD_LIBRARY_PATH="${conda}/envs/pangenome/lib:$LD_LIBRARY_PATH"

#Make output directory
if [[ ! -d ${worflow} ]]
then
	mkdir ${worflow}
fi

#Make check for vcf directory, make if it doesn't exist
if [[ ! -d vcf ]]
then
	mkdir vcf
fi

#Merge vcf files
echo "Merging vcf files"
bcftools merge \
	--threads ${threads} \
	-O z \
	-o vcf/merged.vcf.gz \
	-0 ${vcf}
echo "Indexing vcf file"
bcftools index vcf/merged.vcf.gz

#Set arguments
arguments="-t ${threads} --workflow ${worflow}"
#Set temporary directory
if [ -z tmp_dir ]
then
	arguments="${arguments} --tmp-dir ./"
else
	arguments="${arguments} --tmp-dir ${tmp_dir}"
fi
#Set vcf
if [[ ! -z ${vcf} ]]
then
	arguments="${arguments} --vcf vcf/merged.vcf.gz"
fi

#Run vg autoindex
echo "Running vg autoindex --workflow ${worflow}"
vg autoindex \
	${arguments} \
	--prefix ${worflow}/ \
	--ref-fasta ${ref_fasta}

echo "Done"