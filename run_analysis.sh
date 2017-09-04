#!/bin/bash

cd mitobam
snakemake -s mitobam.snake
snakemake -s mitobam.snake clean
cd ../

cd haplogroup
snakemake -s haplogroup.snake
snakemake -s haplogroup.snake clean
cd ..

cd variants
snakemake -s variants.snake
snakemake -s variants.snake clean
cd ..

cd map
sh map_haplogroup.sh
cd ..

