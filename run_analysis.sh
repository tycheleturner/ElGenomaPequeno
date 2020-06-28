#!/bin/bash

cd mitobam
/opt/conda/bin/snakemake -s mitobam.snake
/opt/conda/bin/snakemake -s mitobam.snake clean
cd ../

cd haplogroup
/opt/conda/bin/snakemake -s haplogroup.snake
/opt/conda/bin/snakemake -s haplogroup.snake clean
cd ..

cd variants
/opt/conda/bin/snakemake -s variants.snake
/opt/conda/bin/snakemake -s variants.snake clean
cd ..

cd map
sh map_haplogroup.sh
cd ..

