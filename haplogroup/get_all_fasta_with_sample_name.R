#!/bin/Rscript
#author: Tychele N. Turner, Ph.D.
#email: tycheleturner@gmail.com

library("seqinr")
files <- list.files(".", pattern="*.cns.fq.fasta")
filesnames <- as.data.frame(sapply(files, function(x) strsplit(x, ".cns.fq.fasta")[[1]][1]))
colnames(filesnames) <- c("sample")
filesnames$index <- 1:nrow(filesnames)

fastafiles <- list()

for(i in 1:length(files)){
	fastafiles[[i]] <- read.fasta(files[i], as.string=TRUE)
}

for(i in 1:length(files)){
	write.fasta(sequences=fastafiles[i], names=filesnames$sample[i], file.out=paste(filesnames$sample[i], ".fasta.for.mega", sep=""), nbchar = 70)
}

