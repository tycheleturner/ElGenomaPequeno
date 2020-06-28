#!/bin/bash
#author: Tychele N. Turner, Ph.D.
#email: tycheleturner@gmail.com

for i in *.haplogroup.txt; do awk -F '\t' '{print FILENAME"\t"$12}' "$i"| head -2 | tail -1 ; done  > summary_haplogroup.txt
