FROM ubuntu:18.04
MAINTAINER Ekaterina Ivanyutenko <kivanyutenko@gmail.com>
RUN mkdir -p /usr/SOFT/
WORKDIR /SOFT/

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y wget xz-utils autoconf automake \
    make gcc perl zlib1g-dev libbz2-dev liblzma-dev \
    libcurl4-gnutls-dev libssl-dev libncurses5-dev  && \
    apt-get clean && apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#Samtools with htslib-1.11, bcftools-1.11, libdeflate-v1.6
RUN wget https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2  \
	&&tar jxf htslib-1.11.tar.bz2 && rm htslib-1.11.tar.bz2  \
	&&wget  https://github.com/samtools/bcftools/releases/download/1.11/bcftools-1.11.tar.bz2\
	&&tar jxf bcftools-1.11.tar.bz2 && rm bcftools-1.11.tar.bz2  \
	&&wget https://github.com/ebiggers/libdeflate/archive/v1.6.tar.gz \
	&&tar xzf v1.6.tar.gz && rm v1.6.tar.gz && cd libdeflate-1.6  \
	&&make && make install && cd .. \
	&&wget https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2  \
	&&tar jxf samtools-1.11.tar.bz2  \
	&& cd samtools-1.11 \
	&&./configure --enable-configure-htslib --enable-plugins --with-libdeflate --prefix $(pwd) \
	--enable-libcurl --enable-gcs --enable-s3 --with-plugin-path=/SOFT/htslib-1.11/  \
	&&make all all-htslib && cd ..

#Biobambam2
RUN wget https://gitlab.com/german.tischler/libmaus2/-/archive/2.0.757-release-20201005124625/libmaus2-2.0.757-release-20201005124625.tar.bz2\
&& tar jxf libmaus2-2.0.757-release-20201005124625.tar.bz2&& rm libmaus2-2.0.757-release-20201005124625.tar.bz2  \&& cd libmaus2-2.0.757-release-20201005124625\
&&libtoolize\
&&aclocal\
&& autoreconf -i -f \
&& ./configure && make && make install && cd .. \
&&wget https://gitlab.com/german.tischler/biobambam2/-/archive/2.0.175-release-20200827101416/biobambam2-2.0.175-release-20200827101416.tar.bz2  \
&&tar jxf biobambam2-2.0.175-release-20200827101416.tar.bz2 \
&&rm biobambam2-2.0.175-release-20200827101416.tar.bz2\
&& cd biobambam2-2.0.175-release-20200827101416\
&& ./configure --with-libmaus2=${LIBMAUSPREFIX} \
--prefix=${HOME}/biobambam2\

				

ENV LD_LIBRARY_PATH=/SOFT/libdeflate-1.6
ENV PATH=${PATH}:/SOFT/samtools-1.11:/SOFT/biobambam2/2.0.175/:/SOFT/libdeflate-1.6:/SOFT/samtools-1.11/htslib-1.11:/SOFT/samtools-1.11/bcftools-1.11
