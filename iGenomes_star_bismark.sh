#!/bin/bash

IG_ROOT='/sw/data/uppnex/igenomes'
PROJECT='b2013064'
CORES=8

for d in ${IG_ROOT}/*/*/*/Sequence/
do
    cd $d

    # BISMARK REFERENCES
    # NOTES
    # - Default bowtie versions aren't most recent
    # - Annoyingly has to be run twice, once for bowtie1 and once for bowtie2
    #   also can't be in parallel. I've complained to author about this ;)

    mkdir BismarkIndex
    cd BismarkIndex
    ln -s ../WholeGenomeFasta/genome.fa ./genome.fa

    cat > make_bismark.sh <<EOL
#!/bin/bash -l

#SBATCH -A ${PROJECT}
#SBATCH -p core
#SBATCH -n ${CORES}
#SBATCH -t 12:00:00
#SBATCH -J bismark${d}
#SBATCH -o make_bismark_ref.out

## BISMARK INDEX
module load bismark
module load bowtie/1.1.0
module load bowtie2/2.2.3
bismark_genome_preparation ./
bismark_genome_preparation --bowtie2 ./

EOL

    sbatch make_bismark.sh
    cd ../

    # STAR REFERENCE
    mkdir STARIndex
    cd STARIndex
    ln -s ../WholeGenomeFasta/genome.fa ./genome.fa

    GTFFILE=''
    if [ -e ../../Annotation/Genes/genes.gtf ]
    then
        ln -s ../../Annotation/Genes/genes.gtf genes.gtf
        GTFFILE='--sjdbGTFfile genes.gtf --sjdbOverhang 100'
    fi

    cat > make_star.sh <<EOL
#!/bin/bash -l

#SBATCH -A ${PROJECT}
#SBATCH -p core
#SBATCH -n ${CORES}
#SBATCH -t 4:00:00
#SBATCH -J star${d}
#SBATCH -o make_star_ref.out

# STAR INDEX
module load star
STAR  --runMode genomeGenerate --runThreadN ${CORES} --genomeDir ./ --genomeFastaFiles genome.fa ${GTFFILE}

EOL

    sbatch make_star.sh
    cd ../

done
