## Emacs, make this -*- mode: sh; -*-

## start with the Docker 'base R' Debian-based image
FROM r-base:latest

ARG GITHUB_PAT

LABEL org.opencontainers.licenses="MIT" \
      org.opencontainers.source="https://github.com/davidski/tidyrisk-docker" \
      maintainer="David F. Severski <davidski@deadheaven.com>"

## Remain current
RUN apt-get update -qq \
        && apt-get dist-upgrade -y

## From the Build-Depends of the Debian R package, plus subversion
RUN apt-get update -qq \
    && apt-get install -t unstable -y --no-install-recommends \
        bash-completion \
        bison \
        debhelper \
        default-jdk \
        g++ \
        gcc \
        gdb \
        gfortran \
        groff-base \
        libblas-dev \
        libbz2-dev \
        libcairo2-dev/unstable \
        libcurl4-openssl-dev \
        libjpeg-dev \
        liblapack-dev \
        liblzma-dev \
        libncurses5-dev \
        libpango1.0-dev \
        libpcre3-dev \
        libpng-dev \
        libreadline-dev \
        libtiff5-dev \
        libx11-dev \
        libxt-dev \
        mpack \
        subversion \
        tcl8.6-dev \
        texinfo \
        texlive-base \
        texlive-extra-utils \
        texlive-fonts-extra \
        texlive-fonts-recommended \
        texlive-generic-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        texlive-latex-recommended \
        tk8.6-dev \
        x11proto-core-dev \
        xauth \
        xdg-utils \
        xfonts-base \
        xvfb \
        zlib1g-dev

## Check out R-devel
RUN cd /tmp \
        && svn co https://svn.r-project.org/R/trunk R-devel

## Build and install according the standard 'recipe' Dirk emailed/posted years ago
RUN cd /tmp/R-devel \
    && R_PAPERSIZE=letter \
        R_BATCHSAVE="--no-save --no-restore" \
        R_BROWSER=xdg-open \
        PAGER=/usr/bin/pager \
        PERL=/usr/bin/perl \
        R_UNZIPCMD=/usr/bin/unzip \
        R_ZIPCMD=/usr/bin/zip \
        R_PRINTCMD=/usr/bin/lpr \
        LIBnn=lib \
        AWK=/usr/bin/awk \
        CFLAGS=$(R CMD config CFLAGS) \
        CXXFLAGS=$(R CMD config CXXFLAGS) \
    ./configure --enable-R-shlib \
               --enable-long-double=no \
               --without-blas \
               --without-lapack \
               --with-readline \
               --without-recommended-packages \
               --program-suffix=dev \
    && make \
    && make install \
    && rm -rf /tmp/R-devel


## Set Renviron to get libs from base R install
RUN echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron

## Set default CRAN repo
RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /usr/local/lib/R/etc/Rprofile.site

RUN cd /usr/local/bin \
        && mv R Rdevel \
        && mv Rscript Rscriptdevel \
        && ln -s Rdevel RD \
        && ln -s Rscriptdevel RDscript

## needed packages for evaluator testing
RUN apt-get install -y git libssl-dev libxml2-dev libproj-dev

## get evaluator & dependencies
RUN rm -rf /usr/local/lib/R/site-library/* \
  && Rdevel -e 'install.packages("remotes", dependencies = TRUE)' \ 
  && cd ~ \
  && git clone https://github.com/davidski/evaluator.git \
  && cd evaluator \
  && Rdevel -e 'remotes::install_deps(dep=TRUE)'
