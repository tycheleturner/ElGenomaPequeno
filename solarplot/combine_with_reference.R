#!/bin/Rscript
# Tychele N. Turner, Ph.D.
# August 22, 2018
# Combine count data with reference allele

library("optparse")
 
option_list <- list(
	make_option(c('-v', '--variant'), action='store', type='character', default='file.txt', help='Variant file created from the variant directory'),
	make_option(c('-p', '--phenotype'), action='store', type='character', default='all', help='Phenotype name'),
	make_option(c('-o', '--output'), action='store', type='character', default='output.txt', help='Output file name')
)
opt <- parse_args(OptionParser(option_list = option_list))
 
var = opt$variant
pheno = opt$phenotype
out = opt$output

#load reference file
ref <- read.delim("mitochondrial_reference_file.txt")

#load variant file
var <- read.delim(var, header=F)

#combine reference and variant files
m <- merge(ref, var, by.x="bp", by.y="V1", all.x=T)

#fill in empty counts with 0
m$V2[is.na(m$V2)] <- 0

#add phenotype name
m$pheno <- pheno

mfinal <- m[,c("chr", "snp", "bp", "allele", "pheno", "V2")]
colnames(mfinal) <- c("chr", "snp", "bp", "allele", "pheno", "count")

write.table(mfinal, file=out, sep="\t", quote=F, row.names=F)

