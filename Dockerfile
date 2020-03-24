# 1. install ubuntu & basic tools 
FROM ubuntu:18.04 
MAINTAINER Eugene Kim "eugenekim@mz.co.kr" 
RUN apt-get -y update 
RUN apt install -y build-essential 
RUN apt-get install -y gcc make 
RUN apt-get install -y gfortran 
RUN apt-get update 

# 2. Install MPI(OpenMPI) 
ADD https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.gz /root/
RUN tar -xzvf /root/openmpi-4.0.1.tar.gz -C /root/ 
WORKDIR /root/openmpi-4.0.1 
RUN ./configure 
RUN make install 

# set MPI library path 
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib 
ENV PATH $PATH:/usr/local/bin 

# Install openssh 
RUN apt-get install -y openssh-client 

# 3. Install BLAS (in the LAPACK.. https://www.assistedcoding.eu/2017/11/04/how-to-install-lapacke-ubuntu/) 
RUN apt install -y liblapack3 
RUN apt install -y libopenblas-base 
RUN apt install -y libopenblas-dev 
RUN apt install -y liblapacke-dev 
RUN apt install -y liblapack-dev 

# 4. Install HPL (http://www.netlib.org/benchmark/hpl/) 
# http://www.netlib.org/benchmark/hpl/software.html 
ADD http://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz /root/ 
RUN tar -xzvf /root/hpl-2.3.tar.gz -C /root/ 
WORKDIR /root/hpl-2.3 
COPY ./Make.x86_64 /root/hpl-2.3/Make.x86_64 
RUN make arch=x86_64 

# fix errno=1 
ENV OMPI_MCA_btl_vader_single_copy_mechanism none
