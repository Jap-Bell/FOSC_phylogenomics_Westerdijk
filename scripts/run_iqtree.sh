#!/bin/bash

treefile="$1"

model=$(grep "Best-fit model:" "$treefile" | cut -d " " -f3)

echo "iqtree -s "$treefile" -m "$model" -nt AUTO -prefix bootstrapped/"
