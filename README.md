# Junior_task
# Install samtools and biobambam

The image contains a install of [samtools](https://github.com/samtools/samtools) and [biobambam](https://gitlab.com/german.tischler/biobambam2).

The image is set up with:
 - Ubuntu 18.04
 - Samtools 1.11
 - libdeflate 1.16
 - htslib 1.11
 - bcftools 1.11
 - biobambam2 2.0.175

To build the docker image you can do the following  in the folder with Dockerfile:
```bash
$ docker build --tag samtools-biobambam:1. 
```

To run the software you can do the following
```bash
$ docker run -it --rm -v $(pwd):/in -w /in samtools-biobambam:1 /bin/bash
```
