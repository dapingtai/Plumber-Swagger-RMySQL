# Plumber+Swagger+RMySQL
### Deploy the R API enviroment with Plumber, Swagger, and RMySQL

# Quick Start
- Pull images
```shell
docker pull zero102x/plumber-rmysql:swagger_version
```
- Deploy Your API
```shell
docker run -di --name [Your API Name] -p 8000:8000 -v [Your Plumber Path]:/plumber.R zero102x/plumber-rmysql:swagger_version /plumber.R
```
# Build Docker Image By Dockerfile
- Create Dockerfile Path
```shell
mkdir Plumber-Swagger-RMySQL
cd Plumber-Swagger-RMySQL
```
- You can adjust your R packages in command 8, and change swagger=TRUE/FALSE to allow swagger function in command 10
```dockerfile
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
```
- Start Building
```shell
docker -t build plumber-swagger-rmysql . --no-cache
```
# Swagger
- You can manage your API functions by Swagger UI
```https
http://[Your API IP]/__swagger__/
```
![image](https://github.com/dapingtai/Plumber-Swagger-RMySQL/blob/master/Swagger.png)
