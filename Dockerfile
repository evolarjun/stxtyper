FROM ubuntu:jammy

LABEL base.image="ubuntu:jammy"
LABEL software="stxtyper"
LABEL description="STX operon typing"
LABEL website="https://github.com/evolarjun/stxtyper"
LABEL license="https://github.com/evolarjun/stxtyper/blob/main/LICENSE"
LABEL maintainer="Curtis Kapsak"
LABEL maintainer.email="kapsakcj@gmail.com"

# install dependencies via apt; cleanup apt garbage
# blast from ubuntu:jammy is v2.12.0 (as of 2024-03-26)
# procps is for ps command (required for nextflow)
RUN apt-get update && apt-get install -y --no-install-recommends \
 wget \
 ca-certificates \
 make \ 
 g++ \
 ncbi-blast+ \
 procps && \
 apt-get autoclean && rm -rf /var/lib/apt/lists/*

# bring in stxtyper code
COPY . /stxtyper

# compile 
# run test script
# TODO in future: move executables to /usr/local/bin and delete source code (for smaller image) 
RUN cd /stxtyper && \
    make && \
    bash test_stxtyper.sh && \
    tblastn -help && \
    ./stxtyper --help

# set PATH to include where stxtyper & fasta_check executables exist
ENV PATH="${PATH}:/stxtyper" 

# set final working directory as /data for passing data in/out of container
WORKDIR /data
