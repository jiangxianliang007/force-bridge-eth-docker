#!/bin/bash
set -e

export RUST_BACKTRACE=1
export RUST_LOG=error,force=info

DB_NAME=forces
DB_PATH=mysql://dex:root@127.0.0.1:3306/${DB_NAME}
HEADER_RELAY_PRIVKEY=1

cd /opt/force-bridge-eth/offchain-modules/

ckb2eth-relay() {
 force-eth-cli ckb-relay --config-path /opt/config.toml -k ${HEADER_RELAY_PRIVKEY} --per-amount 10 --max-tx-count 10 --mutlisig-privkeys 0
}
eth2ckb-relay() {
 force-eth-cli eth-relay --config-path /opt/config.toml -k ${HEADER_RELAY_PRIVKEY} --multisig-privkeys 0 1
}
force-server() {
  RUST_LOG=error,force=info RUST_TRACEBACK=1 force-eth-cli server --config-path /opt/config.toml --ckb-private-key-path 2 --eth-private-key-path 2  --listen-url 0.0.0.0:3003 --db-path ${DB_PATH} --alarm-url 'https://api.telegram.org/bot1261638669:AAEDKNXUPDbivD_lrjAosfJSnpqIu4rVevE/sendMessage?chat_id=-1001451474483&text='
}
hello() {
 echo "hello world"
}
case $1 in
   ckb2eth-relay)
      ckb2eth-relay
      ;;
   eth2ckb-relay)
      eth2ckb-relay
      ;;
   force-server)
      force-server
      ;;
   *)
      hello
      ;;
esac