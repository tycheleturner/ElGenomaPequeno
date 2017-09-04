#!/bin/R
#author: Tychele N. Turner, Ph.D.
#email: tycheleturner@gmail.com
 
library("optparse")
 
option_list <- list(
	make_option(c('-i', '--inputfile'), action='store', type='character', default='input.txt', help='Input file to test which is the output file of pysamstats'),
	make_option(c('-o', '--outputmutations'), action='store', type='character', default='outputmutations.txt', help='Output file to of all mutations'),
	make_option(c('-v', '--outputheteroplasmy'), action='store', type='character', default='outputheteroplasmy.txt', help='Output file of all heteroplasmic sites'),
	make_option(c('-t', '--threshold'), action='store', type='numeric', default=10, help='Percent threshold at which you will consider a site for mutation and heteroplasmy')
)
opt <- parse_args(OptionParser(option_list = option_list))

inputfile = opt$inputfile 
outputmutations = opt$outputmutations
outputheteroplasmy = opt$outputheteroplasmy
threshold = 100-opt$threshold

#read in the file
inputfile <- read.delim(inputfile)

#calculate percent of each nucleotide and / or indel
inputfile$reads_pp <- apply(inputfile, 1, function(x) sum(as.numeric(x[5]), as.numeric(x[13])))
inputfile$percentA <- round((inputfile$A_pp/inputfile$reads_pp)*100, digits=2)
inputfile$percentC <- round((inputfile$C_pp/inputfile$reads_pp)*100, digits=2)
inputfile$percentG <- round((inputfile$G_pp/inputfile$reads_pp)*100, digits=2)
inputfile$percentT <- round((inputfile$T_pp/inputfile$reads_pp)*100, digits=2)
inputfile$percentdeletions <- round((inputfile$deletions_pp/inputfile$reads_pp)*100, digits=2)
inputfile$percentinsertions <- round((inputfile$insertions_pp/inputfile$reads_pp)*100, digits=2)

#calculate percent reference
for(i in 1:nrow(inputfile)){
	if(inputfile$ref[i] %in% c("A", "C", "G", "T")){
		inputfile$percentRef[i] <- inputfile[,colnames(inputfile)[colnames(inputfile) == paste("percent", as.character(inputfile$ref[i]), sep="")]][i]
	} else {
		inputfile$percentRef[i] <- 101
	}
}

#identify putative variants
putativeVariants <- inputfile[which(inputfile$percentRef < threshold),]
pptest <- putativeVariants[,c(24:30)]
putativeVariants$mostCommon <- as.character(sapply(colnames(pptest)[apply(pptest,1,which.max)], function(x) strsplit(x, "percent")[[1]][2]))

#calculate precent alternate
for(i in 1:nrow(putativeVariants)){
	putativeVariants$percentAlternate[i] <- putativeVariants[i,paste("percent",putativeVariants$mostCommon[i], sep="")]
}

#clean and output
vars <- putativeVariants[,c("chrom", "pos", "ref", "mostCommon", "percentRef", "percentAlternate", "reads_pp")]
colnames(vars) <- c("CHROM", "POS", "REF", "ALT", "PERCENTREF", "PERCENTALT", "DEPTH")
write.table(vars, file=outputmutations, sep="\t", quote=F, row.names=F) 
potentialHeteroplasmy <- inputfile[which(inputfile$pos %in% vars[which(vars$PERCENTALT < threshold),]$POS),]
pptest2 <- potentialHeteroplasmy[c("percentA", "percentC", "percentG", "percentT", "percentdeletions", "percentinsertions")]

#second highest

potentialHeteroplasmy$mostCommon <- as.character(sapply(colnames(pptest2)[apply(pptest2,1,which.max)], function(x) strsplit(x, "percent")[[1]][2]))
n <- ncol(pptest2)
for(i in 1:nrow(pptest2)){
	potentialHeteroplasmy$secondMostCommon[i] <- sapply(colnames(sort(pptest2[i,],partial=n-1)[n-1]), function(x) strsplit(x,"percent")[[1]][2])
}

for(i in 1:nrow(potentialHeteroplasmy)){
	potentialHeteroplasmy$mostCommonPercent[i] <- potentialHeteroplasmy[,paste("percent",potentialHeteroplasmy$mostCommon[i], sep="")][i]
}

for(i in 1:nrow(potentialHeteroplasmy)){
	potentialHeteroplasmy$secondMostCommonPercent[i] <- potentialHeteroplasmy[,paste("percent",potentialHeteroplasmy$secondMostCommon[i], sep="")][i]

}

potentialHeteroplasmy <- potentialHeteroplasmy[,c("chrom", "pos", "ref", "percentRef", "mostCommon", "mostCommonPercent", "secondMostCommon", "secondMostCommonPercent")]
colnames(potentialHeteroplasmy) <- c("CHROM", "POS", "REF", "PERCENTREF", "MAJORALLELE", "MAJORALLELEPERCENT", "MINORALLELE", "MINORALLELEPERCENT")

write.table(potentialHeteroplasmy, file=outputheteroplasmy, sep="\t", quote=F, row.names=F)

