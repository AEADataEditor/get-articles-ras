#!/bin/bash
#

docker run -it --rm -p 8787:8787 \
	-e DISABLE_AUTH=true  \
	-v $(pwd):/home/rstudio \
	-w /home/rstudio \
	rocker/verse \
	R CMD BATCH 01_*.R

