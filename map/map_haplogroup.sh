#!/bin/bash
#author: Tychele N. Turner, Ph.D.
#email: tycheleturner@gmail.com
module load modules modules-init modules-gs
module load R/3.0.0
Rscript map_haplogroup.R -i ../haplogroup/haplogroups_for_mapper.txt -o haplogroup_map.pdf -c coordinates.txt
