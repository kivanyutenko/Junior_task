FROM ubuntu:18.04
MAINTAINER Ekaterina Ivanyutenko <kivanyutenko@gmail.com>

RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y build-essential wget \
		zlib-dev libbz2-dev liblzma-dev libcur-dev  libcrypto-dev&& \
    bzip2-dev xz-dev curl-dev libressl-dev gsl-dev perl-dev &&\
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /SOFT/
#Samtools with htslib-1.11, bcftools-1.11, libdeflate-v1.6

RUN wget https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2  \
	  &&tar jxf htslib-1.11.tar.bz2 && rm htslib-1.11.tar.bz2  \
    &&wget  https://github.com/samtools/bcftools/releases/download/1.11/bcftools-1.11.tar.bz2\
    $$tar jxf bcftools-1.11.tar.bz2 && rm bcftools-1.11.tar.bz2  \
	  &&wget https://github.com/ebiggers/libdeflate/archive/v1.6.tar.gzbz2 \
	  &&tar jfx v1.6.tar.bz2 && rm v1.6.tar.bz2 && cd libdeflate-1.6  \
	  &&make && make install && cd .. \
    &&wget https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2  \
	  &&tar jxf samtools-1.11.tar.bz2  \
    && cd samtools-1.11 \
    &&./configure --enable-configure-htslib --enable-plugins --with-libdeflate --prefix $(pwd) \
	  --enable-libcurl --enable-gcs --enable-s3 --with-plugin-path=/SOFT/htslib-1.11/  \
	  &&make all all-htslib && cd ..

#Biobambam2
  RUN wget https://gitlab.com/german.tischler/biobambam2/-/archive/2.0.175-release-20200827101416/biobambam2-2.0.175-release-20200827101416.tar.bz2 \ \
    &&tar jxf biobambam2-2.0.175-release-20200827101416.tar.bz2 \
  	&&rm biobambam2-2.0.175-release-20200827101416.tar.bz2

ENV LD_LIBRARY_PATH=/SOFT/libdeflate-1.6
ENV PATH=${PATH}:/SOFT/samtools-1.11:/SOFT/biobambam2//2.0.175/bin/:/SOFT/libdeflate-1.6:/SOFT/samtools-1.11/htslib-1.11:/SOFT/samtools-1.11/bcftools-1.11
