FROM ubuntu:16.04
RUN apt-get -y update && apt-get -y install git make gcc g++ bc zlib1g-dev python-pip \
                        python-dev python-jinja2 python-tornado python-nose screen  \
                        python-numpy python-matplotlib curl wget unzip pkg-config
# Install Tallymer
WORKDIR /usr/local/src
RUN wget http://genometools.org/pub/genometools-1.5.9.tar.gz # changed the version from 1.5.1 to 1.5.9 here
RUN tar xvf genometools-1.5.9.tar.gz
WORKDIR genometools-1.5.9/
RUN make 64bit=yes curses=no cairo=no
RUN make 64bit=yes curses=no cairo=no install
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
WORKDIR dsk-1.5031
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
# Install Turtle
WORKDIR /usr/local/src
RUN wget http://bioinformatics.rutgers.edu/Static/Software/Turtle/Turtle-0.3.1.tar.gz
RUN tar zxvf Turtle-0.3.1.tar.gz
WORKDIR Turtle-0.3
RUN make
RUN mv *Turtle32 *Turtle64 /usr/local/bin/
# Install KAnalyze
WORKDIR /usr/local/src
RUN wget http://downloads.sourceforge.net/project/kanalyze/v0.9.3/kanalyze-0.9.3-linux.tar.gz
RUN tar zxvf kanalyze-0.9.3-linux.tar.gz
# Install QUAST
WORKDIR /usr/local/src
RUN wget http://downloads.sourceforge.net/project/quast/quast-2.3.tar.gz
RUN tar zxvf quast-2.3.tar.gz
# Install FASTX-toolkit
WORKDIR /usr/local/src
RUN curl -O http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-0.6.1.tar.bz2
RUN tar xjf libgtextutils-0.6.1.tar.bz2
WORKDIR libgtextutils-0.6.1/
RUN ./configure && make && make install
WORKDIR /usr/local/src
RUN curl -O http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-0.0.13.2.tar.bz2
RUN tar xjf fastx_toolkit-0.0.13.2.tar.bz2
WORKDIR fastx_toolkit-0.0.13.2/
RUN ./configure && make && make install
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
# install Java ## Not done yet (I did not find a way to install jre-7.5.1)
RUN apt-get install -y default-jre
# Install ipython (Changed here because current github mater code cannot be installed on python2.7)
WORKDIR /usr/local/src
RUN wget https://github.com/ipython/ipython/archive/5.3.0.tar.gz 
RUN tar xvf 5.3.0.tar.gz
WORKDIR ipython-5.3.0/
RUN python setup.py install
# Upgrade pyzmq, which is required by ipython notebook
RUN pip install pyzmq --upgrade
# Upgrade some other packages required by ipython notebook to draw figures
WORKDIR /usr/local/src
RUN pip install pandas
RUN pip install --upgrade patsy
RUN apt-get install -y libfreetype6-dev libpng-dev
RUN pip install seaborn
RUN pip install --upgrade statsmodels
RUN pip install --upgrade tornado
# Upgrade the latex install with a few recommended packages
RUN apt-get -y install texlive-latex-recommended
# Install Velvet
WORKDIR /usr/local/src
RUN wget https://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz # fixed the correct url
RUN tar xvzf velvet_1.2.10.tgz
WORKDIR velvet_1.2.10/
RUN make 'MAXKMERLENGTH=49'
RUN cp velveth /usr/bin
RUN cp velvetg /usr/bin
# Install Screed and Khmer (changed screed and khmer installations)
WORKDIR /usr/local/src
RUN git clone git://github.com/ged-lab/screed.git
WORKDIR screed
RUN python setup.py install
RUN pip install khmer
