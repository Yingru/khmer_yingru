FROM ubuntu:14.04
MAINTAINER yx59@duke.edu

ENV PACKAGES git make gcc g++ bc zlib1g-dev python-pip \
	     python-dev python-jinja2 python-tornado python-nose screen \
	     python-numpy python-matplotlib wget curl unzip pkg-config time

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} 


# Install Turtle
WORKDIR /usr/local/src
RUN wget http://bioinformatics.rutgers.edu/Static/Software/Turtle/Turtle-0.3.1.tar.gz
RUN tar zxvf Turtle-0.3.1.tar.gz
WORKDIR Turtle-0.3
RUN make
RUN mv  *Turtle32 *Turtle64 /usr/local/bin/


# Install KAnalyze
WORKDIR /usr/local/src
RUN wget http://downloads.sourceforge.net/project/kanalyze/v0.9.3/kanalyze-0.9.3-linux.tar.gz
RUN tar zxvf kanalyze-0.9.3-linux.tar.gz


# Install QUAST
WORKDIR /usr/local/src
RUN wget http://downloads.sourceforge.net/project/quast/quast-2.3.tar.gz
RUN tar zxvf quast-2.3.tar.gz


# Install Tallymer
WORKDIR /usr/local/src
RUN wget http://genometools.org/pub/genometools-1.5.9.tar.gz  # change version from 1.5.1->1.5.9
RUN tar zxvf genometools-1.5.9.tar.gz
WORKDIR genometools-1.5.9/
RUN make 64bit=yes curses=no cairo=no errorcheck=no
RUN make 64bit=yes curses=no cairo=no errorcheck=no install



# Install Jellyfish
WORKDIR /usr/local/src
RUN wget http://www.cbcb.umd.edu/software/jellyfish/jellyfish-1.1.10.tar.gz
RUN tar zxvf jellyfish-1.1.10.tar.gz
WORKDIR jellyfish-1.1.10/
RUN ./configure && make && make install



# Install DSK
WORKDIR /usr/local/src
RUN ldconfig
RUN wget http://minia.genouest.org/dsk/dsk-1.5031.tar.gz
RUN tar zxvf dsk-1.5031.tar.gz
WORKDIR dsk-1.5031/
RUN make omp=1
RUN cp dsk /usr/local/bin


# Install KMC
WORKDIR /usr/local/src
RUN wget http://sun.aei.polsl.pl/kmc/download/kmc
RUN wget http://sun.aei.polsl.pl/kmc/download/kmc_dump
RUN chmod u+x kmc kmc_dump
RUN mv kmc kmc_dump /usr/local/bin/


# Install BFCount
WORKDIR /usr/local/src
RUN git clone https://github.com/pmelsted/BFCounter.git
WORKDIR BFCounter/
RUN make
RUN mv ./BFCounter /usr/local/bin/


# Install FASTX-toolkit
WORKDIR  /usr/local/src
RUN curl -O http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-0.6.1.tar.bz2
RUN tar xjf libgtextutils-0.6.1.tar.bz2
WORKDIR libgtextutils-0.6.1/
RUN ./configure && make && make install

WORKDIR /usr/local/src
RUN curl -O http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-0.0.13.2.tar.bz2
RUN tar xjf fastx_toolkit-0.0.13.2.tar.bz2
WORKDIR fastx_toolkit-0.0.13.2/
RUN ./configure && make && make install

#RUN apt-get install fastx-toolkit


# Install Trimmomatic 
WORKDIR /usr/local/src
RUN curl -O http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.30.zip
RUN unzip Trimmomatic-0.30.zip
WORKDIR Trimmomatic-0.30/
RUN cp trimmomatic-0.30.jar /usr/local/bin
RUN cp -r adapters /usr/local/share/adapters

# Install seqtk
WORKDIR /usr/local/src
RUN git clone git://github.com/lh3/seqtk.git
WORKDIR seqtk
RUN make
RUN cp seqtk /usr/local/bin


# Install Java
RUN apt-get -y install default-jre


# Install ipython
RUN apt-get -y install ipython


# Upgrade pyzmq, which is required by ipython notebook
RUN pip install pyzmq --upgrade

# Upgrade some other packages required by ipython notebook to draw figures
WORKDIR /usr/local/src
RUN pip install cython
RUN git clone git://github.com/numpy/numpy.git numpy
WORKDIR numpy
RUN python setup.py install

WORKDIR /usr/local/src
RUN pip install pandas
RUN pip install --upgrade patsy
RUN apt-get install libfreetype6-dev libpng-dev
RUN pip install matplotlib

RUN apt-get -y install gfortran

RUN apt-get -y install pkg-config
RUN apt-get -y install libblas-dev liblapack-dev
RUN pip install seaborn
RUN pip install --upgrade six
RUN pip install --upgrade statsmodels
RUN pip install "Tornado>=4.0.0,<5.0.0"



# Upgrade the latex install with a few recommended packages
RUN apt-get -y install texlive-latex-recommended


# Install Velvet
WORKDIR /usr/local/src
RUN wget https://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz
RUN tar xvzf velvet_1.2.10.tgz
WORKDIR velvet_1.2.10/
RUN make 'MAXKMERLENGTH=49'
RUN cp velveth /usr/bin
RUN cp velvetg /usr/bin


# Install Screed
WORKDIR  /usr/local/src
RUN git clone git://github.com/ged-lab/screed.git
WORKDIR screed
RUN git checkout 2013-khmer-counting
RUN python setup.py install


# Install khmer
WORKDIR /usr/local/src
RUN git clone http://github.com/ged-lab/khmer.git
WORKDIR khmer
RUN git checkout 2013-khmer-counting
RUN sed -i 's/http:\/\/pypi.python.org\/packages\/source\/d\/distribute\//https:\/\/pypi.python.org\/packages\/source\/d\/distribute\//g' /usr/local/src/khmer/python/distribute_setup.py
RUN make test


WORKDIR /usr/local/src
RUN echo 'export PYTHONPATH=/usr/local/src/khmer/python' >> ~/.bashrc
RUN echo 'export PATH=$PATH:/usr/local/src/khmer/scripts' >> ~/.bashrc
RUN echo 'export PATH=$PATH:/usr/local/src/khmer/sandbox' >> ~/.bashrc
#RUN source ~/.bashrc

