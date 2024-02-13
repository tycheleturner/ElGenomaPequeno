# EGP: El genoma pequeño - analysis workflow for "the little genome"
### Note: the character ``` ñ ``` is not supported in Github repository names at this time

The mitochondrial workflows in this github have a few purposes. First is to get a high quality mitochondrial genome out of an Illumina sequencing bam or cram file (this workflow assumes this bam/cram was initially mapped to a reference using BWA MEM). Second is to get a representative fasta for the mitochondrial genome and to use Mitomaster to determine its haplogroup. Third is to collect variants from the mitochondria including those which meet some minimum threshold for being a heteroplasmic variant. Finally, it generates a world map with your sample(s) mapped to the location where their haplogroup is thought to have been derived in the world. To generate coordinates, I approximated based on looking at the following map: https://www.mitomap.org/foswiki/pub/MITOMAP/MitomapFigures/WorldMigrations2012.pdf. 

We highly suggest some other analyses for family-based studies such as taking all of the fastas and generating a multi-sequence alignment and tree (they are not currently implemented in this github). The workflows in this github run in ~ 2 minutes per sample.

### Overall Workflow
![EGP Workflow](workflow/EGP_Website.png)

### Requirements:
```
samtools
python
pysam
pysamstats
R
bcftools
picard
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

### To run the analysis locally

```
sh run_analysis.sh
```

### To submit to cluster

```
sh cluster_analysis.sh
```

### Output files:

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

**Note:** if no haplogroup is identified using mitomaster in the haplogroup workflow, the haplogroup is the same as the rCRS reference sequence (H2a2a1). This is from personal communication with the mitomap help email.


### Example setup on a RedHat Linux (may need to ask an system administrator for help if running on your server or alternatively you can set this up in the cloud on a RedHat instance)

```
#update machine
sudo yum -y update

#install basics
sudo yum -y install gcc
sudo yum -y install zlib-devel
sudo yum -y install bzip2-devel
sudo yum -y install xz-devel
sudo yum -y install gcc-c++
sudo yum -y install wget
sudo yum -y install bzip2

#get anaconda and install
wget https://repo.continuum.io/archive/Anaconda2-5.0.1-Linux-x86_64.sh
sh Anaconda2-5.0.1-Linux-x86_64.sh
source ~/.bashrc

#install required for the softwre
conda install -c bioconda samtools
conda install -c bioconda R
conda install -c bioconda pysam
conda install -c bioconda pysamstats
conda install -c bioconda hdf5
conda install -c bioconda bcftools
conda install -c bioconda picard
conda install -c bioconda biopython

conda create -n py35 python=3.5 anaconda
source activate py35
conda install -c bioconda snakemake

#inside of R install the following
install.packages('seqinr')
install.packages('optparse')
install.packages('maps')

#install git
sudo yum -y install git

#testing
git clone https://github.com/tycheleturner/ElGenomaPequeno.git
source activate py35
conda install -c bioconda biopython
conda install pip

source deactivate py35
pip install poster
source activate py35
```

### Example analysis with data from 1000 Genomes

```
#get the data (low pass WGS)
wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/phase3/data/NA19238/alignment/NA19238.mapped.ILLUMINA.bwa.YRI.low_coverage.20130415.bam.cram
wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/phase3/data/NA19240/alignment/NA19240.mapped.ILLUMINA.bwa.YRI.low_coverage.20130415.bam.cram
wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/phase3/data/NA19239/alignment/NA19239.mapped.ILLUMINA.bwa.YRI.low_coverage.20130415.bam.cram

#index crams
for file in *cram
do
samtools index "$file"
done

#get reference files
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz
gunzip human_g1k_v37.fasta.gz
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.fai

cd ElGenomaPequeno

#update config.json as follows (if running in the cloud):
{
  "reference": "/home/ec2-user/human_g1k_v37.fasta",
  "data_dir": "/home/ec2-user/",
  "file_tail": ".mapped.ILLUMINA.bwa.YRI.low_coverage.20130415.bam.cram",
  "picard": "picard",
  "java": "java",
  "mitoname": "MT",
  "mitobam_dir": "../mitobam/",
  "mito_ref": "../reference/MT.fasta",
  "heteroplasmy_threshold": "15"
}

sh run_analysis.sh
```

### Workflows inside of this github

#### Mitobam 
![Mitobam workflow](mitobam/mitobam.png)

#### Haplogroup 
![Haplogroup workflow](haplogroup/haplogroup.png)

#### Variants
![Variants workflow](variants/variants.png)


### Example haplogroup map (from 1000 Genomes dataset)

![This plot was made using data from the Diroma et al. 2014 haplogroup dataset (PMID:25077682, Additional File 1)](examples/1kg.png "1000GenomesHaplogroups")


### Mitochondrial Genome Copy Number from Short-Read WGS
A standalone snake has been added for calculating copy number from the mitochondrial genome. Please see the `mitocn` directory for more details.

### EGP in Publications
#### Here are a few papers that have used some aspect(s) of EGP:

Turner TN, Hormozdiari F, Duyzend MH, McClymont SA, Hook PW, Iossifov I, Raja A, Baker C, Hoekzema K, Stessman HA, Zody MC, Nelson BJ, Huddleston J, Sandstrom R, Smith JD, Hanna D, Swanson JM, Faustman EM, Bamshad MJ, Stamatoyannopoulos J, Nickerson DA, McCallion AS, Darnell R, Eichler EE. Genome Sequencing of Autism-Affected Families Reveals Disruption of Putative Noncoding Regulatory DNA. American journal of human genetics. 2016;98(1):58-74. Epub 2016/01/11. doi: 10.1016/j.ajhg.2015.11.023. PubMed PMID: ![26749308](https://pubmed.ncbi.nlm.nih.gov/26749308/); PMCID: ![PMC4716689](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4716689/).

Turner TN, Coe BP, Dickel DE, Hoekzema K, Nelson BJ, Zody MC, Kronenberg ZN, Hormozdiari F, Raja A, Pennacchio LA, Darnell RB, Eichler EE. Genomic Patterns of De Novo Mutation in Simplex Autism. Cell. 2017;171(3):710-22.e12. Epub 2017/10/03. doi: 10.1016/j.cell.2017.08.047. PubMed PMID: ![28965761](https://pubmed.ncbi.nlm.nih.gov/28965761/); PMCID: ![PMC5679715](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5679715/).

Guo H, Duyzend MH, Coe BP, Baker C, Hoekzema K, Gerdts J, Turner TN, Zody MC, Beighley JS, Murali SC, Nelson BJ, Bamshad MJ, Nickerson DA, Bernier RA, Eichler EE. Genome sequencing identifies multiple deleterious variants in autism patients with more severe phenotypes. Genetics in medicine : official journal of the American College of Medical Genetics. 2019;21(7):1611-20. Epub 2018/12/07. doi: 10.1038/s41436-018-0380-2. PubMed PMID: ![30504930](https://pubmed.ncbi.nlm.nih.gov/30504930/); PMCID: ![PMC6546556](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6546556/).

Hall AN, Turner TN, Queitsch C. Thousands of high-quality sequencing samples fail to show meaningful correlation between 5S and 45S ribosomal DNA arrays in humans. Scientific reports. 2021;11(1):449. Epub 2021/01/13. doi: 10.1038/s41598-020-80049-y. PubMed PMID: ![33432083](https://pubmed.ncbi.nlm.nih.gov/33432083/); PMCID: ![PMC7801704](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7801704/).

