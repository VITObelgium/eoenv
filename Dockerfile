FROM ubuntu:bionic

LABEL Daniele Zanaga <daniele.zanaga@vito.be>

ADD ./environment.yml .
RUN sed "s/name: eo/name: base/g" environment.yml > environment_base.yml

RUN apt-get -qq update && apt-get -qq -y install curl bzip2 gcc \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda update conda \
    && conda env update -f environment_base.yml \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes

ENV PATH /opt/conda/bin:$PATH




