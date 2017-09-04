# El genoma pequeño - analysis workflow for "the little genome"
### Note: the character ``` ñ ``` is not supported in Github repository names at this time

The mitochondrial workflows in this github have a few purposes. First is to get a high quality mitochondrial genome out of an Illumina sequencing bam or cram file. Second is to get a representative fasta for the mitochondrial genome and to use Mitomaster to determine it’s haplogroup. Third is to collect variants from the mitochondria including those which meet some minimum threshold for being a heteroplasmic variant. Finally, it generates a world map with your sample(s) mapped to the location where their haplogroup is thought to have been derived in the world. We highly suggest some other analyses for family-based studies such as taking all of the fastas and generating a multi-sequence alignment and tree. They are not implemented in this github. Currently, the workflows in this github run in ~ 2 minutes per sample.

Requirements:
```

samtools/0.1.19
python/2.7.3
pysam/0.8.4
pysamstats/0.24.2
hdf5/1.8.13
netcdf/4.3.2
R/3.1.0
samtools/1.4
bcftools/1.3.1
samtools/1.3
python/2.7.2
picard-tools-2.5.0
jre1.8.0_65
R package: seqinr
R package: optparse
Python package: biopython

```

Users will want to set up the config.json to point to the required information

```

reference: path to the reference that was used for generating the BAM/CRAM
data_dir: path to the BAM/CRAM file
file_tail: end of BAM/CRAM file name (for example if your file is named sample1.final.cram this would be .final.cram)
picard: path to the picard-tools-2.5.0/picard.jar
java: path to the jre1.8.0_65/bin/java
mitoname: The name of the mito as in the file (chrM or MT)
mitobam_dir: this is fixed (do not change)
mito_ref: path to the mitochondrial reference genome the human MT and chrM are located in the github at reference/chrM.fasta

```

To run the analysis locally

```

sh run_analysis.sh

```

To submit to cluster

```

sh cluster_analysis.sh

```

Output files:

```
haplogroup/sample.fasta.for.mega : One fasta file for each sample (can be loaded into MEGA for tree building)
haplogroup/sample.haplogroup.txt : One MitoMaster result file for each sample
haplogroup/summary_haplogroup.txt : Summary file of all haplogroups
mitobam/sample.MT.clean.name.bam : One bam file for each sample
mitobam/sample.MT.clean.name.bam.bai : One bai file for each sample
variants/sample.pysamstats.heteroplasmy.txt : One heteroplasmy site file per person
variants/sample.pysamstats.variants.txt : One variant site file per person
map/haplogroup_map.pdf : A world map with all of the samples 

```

