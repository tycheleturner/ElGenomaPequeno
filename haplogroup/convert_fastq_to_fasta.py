#! /usr/bin/env python
#author: Tychele N. Turner, Ph.D.
#email: tycheleturner@gmail.com
import sys
from Bio import SeqIO

try:
       fname = sys.argv[1]
except:
       sys.stderr.write("Usage: \n")
       sys.exit(1)

f = open(fname)
from Bio import SeqIO
SeqIO.convert(f, "fastq", str(fname)+".fasta", "fasta")

