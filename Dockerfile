FROM ubuntu:20.04

ENV LC_ALL=C
ENV PATH=/bin/EToKi/externals/SPAdes-3.15.2-Linux/bin:/bin/EToKi/externals:/bin/EToKi:${PATH}
ENV ETOKI_PATH=/bin/EToKi/

#Prevent interactive prompts during build
ARG DEBIAN_FRONTEND=noninteractive

#Install dependencies
RUN apt-get update && apt-get install -y build-essential g++ wget git libz-dev curl python3.8 python3-distutils default-jre unzip

#Install pip
RUN ln -s /bin/python3.8 /bin/python
WORKDIR /bin
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py

#Install quast and other required python libraries
RUN pip install quast ete3 numpy==1.20.3 pandas scikit-learn psutil matplotlib numba --ignore-installed

# Install EtoKI (will also install assemblers: spades / megahit, and download usearch executable)
WORKDIR /bin
RUN wget "https://www.drive5.com/downloads/usearch11.0.667_i86linux32.gz"
RUN gunzip usearch11.0.667_i86linux32.gz
RUN chmod +x usearch11.0.667_i86linux32


COPY . ./EToKi
WORKDIR /bin/EToKi

# RUN git checkout Warwick
# RUN git pull origin Warwick
RUN python EToKi.py configure --install --usearch /bin/usearch11.0.667_i86linux32

CMD ["/bin/bash"]
