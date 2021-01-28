FROM node:14.15.0
#FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
 openssl \
 ca-certificates

WORKDIR /opt

ADD ./force-bridge-eth /opt/force-bridge-eth
RUN cd force-bridge-eth/offchain-modules/eth-proof && npm install
COPY ./force-eth-cli /bin/
COPY ./config.toml .
COPY ./entrypoint.sh .

EXPOSE 3003
ENTRYPOINT ["/opt/entrypoint.sh"]

