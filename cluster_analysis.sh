#!/bin/bash

cd mitobam
/opt/conda/bin/snakemake --cluster 'qsub {params.sge_opts}' -j 100 -s mitobam.snake -w 60 --rerun-incomplete -k
/opt/conda/bin/snakemake -s mitobam.snake clean
cd ../

cd haplogroup
/opt/conda/bin/snakemake --cluster 'qsub {params.sge_opts}' -j 1 -s haplogroup.snake -w 60 --rerun-incomplete -k
/opt/conda/bin/snakemake -s haplogroup.snake clean
cd ..

cd variants
/opt/conda/bin/snakemake --cluster 'qsub {params.sge_opts}' -j 100 -s variants.snake -w 60 --rerun-incomplete -k
/opt/conda/bin/snakemake -s variants.snake clean
cd ..

cd map
sh map_haplogroup.sh
cd ..

