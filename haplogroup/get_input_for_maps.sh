#!/bin/bash
#author: Tychele N. Turner, Ph.D.
#email: tycheleturner@gmail.com

for i in *haplogroup.txt; do head -3 "$i" | tail -1 | cut -f12 | awk -F '' '{print $1}' | sed '/^\s*$/d'; done > haplogroups_for_mapper.txt
