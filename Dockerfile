FROM ubuntu

RUN apt-get update \
  && apt-get install -y curl \
                        rake \
                        lsb \
                        sudo \
                        git

COPY . /dots/

WORKDIR /dots

RUN rake
