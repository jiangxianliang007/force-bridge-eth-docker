FROM node:14.15.0
#FROM ubuntu:18.04

ENV BRANCH dapp-lib-testnet
RUN apt-get update && apt-get install -y \
 openssl \
 ca-certificates \
 git

WORKDIR /opt

RUN git clone -b ${BRANCH} https://github.com/nervosnetwork/force-bridge-eth.git
RUN cd force-bridge-eth/ \
    git submodule update --init
RUN cd force-bridge-eth/offchain-modules/eth-proof && yarn
COPY ./force-eth-cli /bin/
COPY ./config.toml /opt/
COPY ./entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh
RUN mkdir logs

EXPOSE 3003
ENTRYPOINT ["/opt/entrypoint.sh"]


