#!/bin/Rscript
# Tychele N. Turner, Ph.D.
# Script to calculate mitochondrial genome copy number
# Last Update: February 5, 2024

# load the parser library
library("optparse")

# Setup arguments
option_list <- list(
	make_option(c("-o", "--output"), type = "character", default = "mitochondrial_genome_copy_number.txt", help = "Output text file with mitochondrial genome copy number", metavar = "mitochondrial_genome_copy_number.txt")
)

args <- parse_args(OptionParser(option_list=option_list))

# list the files
mitofiles <- list.files(".", pattern="*.mt.average.depth.txt.gz")
chr1files <- list.files(".", pattern=".chr1.average.depth.txt")

# read in the files
mito <- list()
chr1 <- list()

for(i in 1:length(mitofiles)){
	mito[[i]] <- read.delim(gzfile(mitofiles[i]), header=F)
	mito[[i]]$sample <- sapply(mitofiles[i], function(x) strsplit(x, ".mt")[[1]][1])
	mito[[i]]$V1 <- as.numeric(gsub("mean: ", "", mito[[i]]$V1))
	chr1[[i]] <- read.delim(gzfile(chr1files[i]), header=F)
	chr1[[i]]$sample <- sapply(chr1files[i], function(x) strsplit(x, ".chr1")[[1]][1])
	chr1[[i]]$V1 <- as.numeric(gsub("mean: ", "", chr1[[i]]$V1))
}

mitocomb <- do.call("rbind", mito)
colnames(mitocomb) <- c("avg_mito_coverage", "sample")
chr1comb <- do.call("rbind", chr1)
colnames(chr1comb) <- c("avg_chr1_coverage", "sample")

# combine data
m <- merge(chr1comb, mitocomb, by="sample")

# calculate copy number
m$mito_cn <- round((m$avg_mito_coverage/m$avg_chr1_coverage)*2, digits=2)

# write out results
write.table(m, file=args$output, sep="\t", quote=F, row.names=F)

