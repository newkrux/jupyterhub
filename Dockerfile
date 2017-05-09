FROM ubuntu:latest
MAINTAINER John Parra <newkrux@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
#ARG http_proxy
#ARG https_proxy
#ENV http_proxy ${http_proxy:- }
#ENV https_proxy ${https_proxy:- }
RUN echo $http_proxy
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install wget locales git bzip2 scilab julia octave texlive texlive-xetex gnuplot python-software-properties software-properties-common  apt-transport-https libcurl4-openssl-dev libssl-dev python-pip&& \ 
    add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'&& \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
    apt-get update -y && apt-get -y install r-base && \
    apt-get remove -y locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV LANG C.UTF-8

RUN wget -q https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh -O /tmp/miniconda.sh  && \
    echo 'd0c7c71cc5659e54ab51f2005a8d96f3 */tmp/miniconda.sh' | md5sum -c - && \
    bash /tmp/miniconda.sh -f -b -p /opt/conda && \
    /opt/conda/bin/conda install --yes -c conda-forge python=3.5 sqlalchemy tornado jinja2 traitlets requests pip nodejs configurable-http-proxy && \
    /opt/conda/bin/pip install --upgrade pip && \
    rm /tmp/miniconda.sh
ENV PATH=/opt/conda/bin:$PATH

ADD . /src/jupyterhub
WORKDIR /src/jupyterhub

RUN python setup.py js && pip install . && \
    rm -rf $PWD ~/.cache ~/.npm
RUN pip install jupyter numpy scipy bokeh matplotlib scikit-learn pandas seaborn octave_kernel pandoc tensorflow scilab_kernel scilab2py 
RUN python -m octave_kernel.install
RUN mkdir -p /srv/jupyterhub/
RUN python -m scilab_kernel.install
COPY installR.r /srv/jupyterhub/
RUN Rscript /srv/jupyterhub/installR.r
COPY installJulia.jl /srv/jupyterhub/
RUN pip2 install --upgrade pip
RUN python2.7 -m pip install ipykernel
RUN python2 -m ipykernel install --user
RUN julia /srv/jupyterhub/installJulia.jl
RUN wget https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb &&dpkg -i pandoc-1.19.2.1-1-amd64.deb
WORKDIR /srv/jupyterhub/
EXPOSE 8000

LABEL org.jupyter.service="jupyterhub"

CMD ["jupyterhub"]
