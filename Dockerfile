FROM rocker/r-base
MAINTAINER Jeff Allen <docker@trestletech.com>

RUN apt-get update -qq && apt-get install -y \
  git-core \
  libssl-dev \
  libcurl4-gnutls-dev

## RUN R -e 'install.packages(c("devtools"))'
## RUN R -e 'devtools::install_github("trestletech/plumber")'
RUN install2.r plumber

RUN apt update -y --allow-releaseinfo-change
RUN apt upgrade -y
RUN apt install -y libmysqlclient-dev
RUN R -e 'install.packages(c("DBI","RMySQL"))'

EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=8000, swagger=TRUE)"]
CMD ["/usr/local/lib/R/site-library/plumber/examples/04-mean-sum/plumber.R"]
