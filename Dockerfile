FROM node:14.15.0
#FROM ubuntu:18.04

ENV BRANCH dapp-lib
RUN apt-get update && apt-get install -y \
 openssl \
 ca-certificates \
 git

WORKDIR /opt

RUN git clone -b ${BRANCH} https://github.com/nervosnetwork/force-bridge-eth.git
RUN cd force-bridge-eth/offchain-modules/eth-proof && npm install
COPY ./force-eth-cli /bin/
COPY ./config.toml .
COPY ./entrypoint.sh .
RUN chmod +x ./entrypoint.sh

EXPOSE 3003
ENTRYPOINT ["/opt/entrypoint.sh"]

