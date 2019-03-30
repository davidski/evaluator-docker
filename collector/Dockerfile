FROM rocker/rstudio:3.5.3

ARG EVALUATOR_VERSION
ARG GITHUB_TOKEN

LABEL maintainer="davidski@deadheaven.com"

RUN export ADD=shiny && bash /etc/cont-init.d/add

RUN apt-get update \
    && apt-get install -y zlib1g-dev libproj-dev \
    && install2.r --deps=TRUE remotes \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://api.github.com/repos/davidski/collector/git/refs/heads/master?access_token=$GITHUB_TOKEN version.json

RUN installGithub.r --deps=TRUE davidski/collector \
                          && apt-get clean \
                          && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /data

EXPOSE 8787
EXPOSE 3838