#!/bin/Rscript
# Mitochondrial solar plots for variant data
# Adapted from: https://github.com/tidyverse/ggplot2/wiki/Plotting-Mitochondrial-Genetic-Association-Results (received permission from Hadley Wickham to modify his original code before commiting this updated version of the code); also looked at https://github.com/stephenturner/solarplot which is also based on the wiki link above
# Updated to work with counts by Tychele N. Turner, Ph.D.
# Additional updates December 2022

# Load libraries
library("optparse")
library("tidyverse")
library("ggplot2")

option_list <- list(
	make_option(c('-i', '--input_file'), action='store', type='character', default='input.txt', help='This is the input file (tab-delimited) to the program and requires "chr snp    bp	allele	pheno	count"'),
	make_option(c('-o', '--output_file'), action='store', type='character', default='output.pdf', help='Output file name')
)
opt <- parse_args(OptionParser(option_list = option_list))

infile = opt$input_file
outfile = opt$output_file

# input file
mitodata <- read.delim(file=infile)

# Sets gene names for bp ranges
addgenelabel <- function(bp,gene) { gene <- ifelse(bp < 577,gene <- "Control-Region", ifelse(bp < 648,gene <- "tRNA", ifelse(bp < 1602,gene <- "rRNA", ifelse(bp < 1671,gene <- "tRNA", ifelse(bp < 3230,gene <- "rRNA", ifelse(bp < 3305,gene <- "tRNA", ifelse(bp < 3307,gene <- "Non-Coding", ifelse(bp < 4263,gene<- "ND1", ifelse(bp < 4332,gene <- "tRNA", ifelse(bp < 4401,gene <- "tRNA", ifelse(bp < 4402,gene <- "Non-Coding", ifelse(bp < 4470,gene <- "tRNA", ifelse(bp < 5512,gene <- "ND2", ifelse(bp < 5580,gene <- "tRNA", ifelse(bp < 5587,gene <- "Non-Coding", ifelse(bp < 5656,gene <- "tRNA", ifelse(bp < 5657,gene <- "Non-Coding", ifelse(bp < 5730,gene <- "tRNA", ifelse(bp < 5826,gene <- "tRNA", ifelse(bp < 5892,gene <- "tRNA", ifelse(bp < 5904,gene <- "Non-Coding", ifelse(bp < 7446,gene <- "CO1", ifelse(bp < 7515,gene <- "tRNA", ifelse(bp < 7518,gene <- "Non-Coding", ifelse(bp < 7586,gene <- "tRNA", ifelse(bp < 8270,gene <- "CO2", ifelse(bp < 8295,gene <- "Non-Coding", ifelse(bp < 8365,gene <- "tRNA", ifelse(bp < 8366,gene <- "Non-Coding", ifelse(bp < 8573,gene <- "ATP8", ifelse(bp < 9208,gene <- "ATP6", ifelse(bp < 9991,gene <- "CO3", ifelse(bp < 10059,gene <- "tRNA", ifelse(bp < 10405,gene <- "ND3", ifelse(bp < 10470,gene <- "tRNA", ifelse(bp < 10767,gene <- "ND4L", ifelse(bp < 12138,gene <- "ND4", ifelse(bp < 12207,gene <- "tRNA", ifelse(bp < 12266,gene <- "tRNA", ifelse(bp < 12337,gene <- "tRNA", ifelse(bp < 14149,gene <- "ND5", ifelse(bp < 14674,gene <- "ND6", ifelse(bp < 14743,gene <- "tRNA", ifelse(bp < 14747,gene <- "Non-Coding", ifelse(bp < 15888,gene <- "CYB", ifelse(bp < 15954,gene <- "tRNA", ifelse(bp < 15956,gene <- "Non-Coding", ifelse(bp < 16024,gene <- "tRNA", ifelse(bp < 17000,gene <- "Control-Region"))))))))))))))))))))))))))))))))))))))))))))))))) }

# Add gene names to each SNP
mitodata$gene <- addgenelabel(mitodata$bp,mitodata$gene)

# Display internal structure of mitodata
str(mitodata)

# Creates and stores negative log p as a new variable
mitodata$logcounts <- log10(mitodata$count)

# Adds -3 label to y axis
mitodata$extraline <- -3

# Set colors for each gene
colours <- c("Control-Region" <- "lightblue4", "tRNA" <- "magenta4", "rRNA" <- "mediumaquamarine", "Non-Coding" <- "sienna4", "ND1" <- "magenta", "ND2" <- "mediumblue", "CO1" <- "olivedrab", "CO2" <- "orange2", "ATP8" <- "orchid4", "ATP6" <- "red3", "CO3" <- "royalblue2", "ND3" <- "palegreen4", "ND4L" <- "grey0", "ND4" <- "pink4", "ND5" <- "yellow4", "ND6" <- "steelblue4", "CYB" <- "tan","red")

# Create gene boundaries and lines
visibleboundaries <- c(1,576,1601,3229,4262,5511,7445,8269,9207,9990,10404,10766,12137,14148,14673,15887)
bdries <- data.frame(x = visibleboundaries,y=-.5)
bdries$gene <- addgenelabel(bdries$x,bdries$gene)
lines <- data.frame(x = seq(0,16569,by=1),y = 0)
lines$gene <- addgenelabel(lines$x,lines$gene)

# Plot
gg <- ggplot(mitodata, aes(x = bp,y = logcounts,color = gene)) +
geom_point()+ coord_polar(direction = 1) +

# the next line adds lines to plot
geom_line(aes(x,2,color = "red"),data = lines) +
geom_line(aes(x,4,color = "red"),data = lines) +
facet_grid(.~pheno) +
geom_line(aes(y=extraline)) +
geom_point(aes(x,y,color = gene),data=lines) +
scale_colour_manual(values = colours,"Genes",breaks = c("Control-Region","tRNA","rRNA","Non-Coding","ND1","ND2","CO1","CO2","ATP8","ATP6","CO3","ND3","ND4L","ND4","ND5","ND6","CYB"),
labels = c("Control Region","tRNA","rRNA","Non-Coding","ND1","ND2","CO1","CO2","ATP8","ATP6","CO3","ND3","ND4L","ND4","ND5","ND6","CYB"))+
xlab("Mitochondrial Base-Pair Location") +
ylab("log10(counts of variants)") +
ggtitle("Frequency of mitochondrial variants")

ggsave(outfile, plot=gg)
