#!/bin/Rscript
#author: Tychele N. Turner, Ph.D.
#email: tycheleturner@gmail.com

#load libraries
library("optparse")
library(maps)

option_list <- list(
	make_option(c('-i', '--input'), action='store', type='character', default='input.txt', help='Input file composed of one haplogroup per line'),
	make_option(c('-o', '--output'), action='store', type='character', default='out.pdf', help='Output pdf file name'),
	make_option(c('-c', '--coordinate'), action='store', type='character', default='latitude_longitude.txt', help='Coordinate file for the mitochondrial haplogroups')
)
opt <- parse_args(OptionParser(option_list = option_list))
 
infile = opt$input
outfile = opt$output
coord = opt$coordinate

#read in the input files
coordinates <- read.delim(coord)
haplogroups <- read.delim(infile, header=F, colClasses = 'character')

#merged coordinates and haplogroups
mer <- merge(haplogroups, coordinates, by.x="V1", by.y="Haplogroups")
mer$actualcoordinate1 <- jitter(mer$coordinate1, amount=4)
mer$actualcoordinate2 <- jitter(mer$coordinate2, amount=4)

#create the map
pdf(outfile, width=10, height=7.5)
map("world", col="gray60", ylim=c(-60, 90), mar=c(0,0,0,0), myborder=0.00001, interior=FALSE)

#add on the longitude and latitude
points(mer$actualcoordinate1, mer$actualcoordinate2, pch=1, cex=0.3, col=as.character(mer$color))

#get haplogroup counts
nvalues <- as.data.frame(table(mer$V1))
mer2 <- merge(mer, nvalues, by.x="V1", by.y="Var1")

#make fancy legends
legendMaterial <- mer2[!duplicated(mer2$V1),]
legend("left", pch=1, col=as.character(legendMaterial$color), legend=paste(as.character(legendMaterial$V1), " (n=", legendMaterial$Freq, ")", sep=""), cex=0.5, bg="white")
dev.off()

