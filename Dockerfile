FROM node:14.15.0
#FROM ubuntu:18.04

ENV BRANCH dapp-lib-testnet
RUN apt-get update && apt-get install -y \
 openssl \
 ca-certificates \
 git

WORKDIR /opt

RUN git clone -b ${BRANCH} https://github.com/nervosnetwork/force-bridge-eth.git
RUN cd force-bridge-eth/offchain-modules/ \
    rm -f eth-proof
RUN git clone https://github.com/LeonLi000/eth-proof.git && cd eth-proof && git checkout 0a2107d196842039b5f032ee57b953a99d6e3fd4 && yarn
COPY ./force-eth-cli /bin/
COPY ./config.toml /opt/
COPY ./entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh
RUN mkdir logs

EXPOSE 3003
ENTRYPOINT ["/opt/entrypoint.sh"]


