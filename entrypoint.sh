#!/bin/bash
set -e

export RUST_BACKTRACE=1
export RUST_LOG=info,force=debug

DB_NAME=forcedb
DB_PATH=mysql://root:root@127.0.0.1:3306/${DB_NAME}
CKB_URL=http://127.0.0.1:8114
INDEXER_URL=http://127.0.0.1:8116
HEADER_RELAY_PRIVKEY=1
CKB_MINT_PRIVKY=2
ETH_UNLOCK_PRIVKEY=2

cd /opt/

ckb-header-relay() {
 force-eth-cli ckb-relay --config-path ./config.toml -k ${HEADER_RELAY_PRIVKEY} --per-amount 10  --max-tx-count 10 --mutlisig-privkeys  0
}
eth-header-relay() {
 force-eth-cli eth-relay --config-path ./config.toml -k ${HEADER_RELAY_PRIVKEY} --multisig-privkeys 0 1
}
force-server() {
  RUST_LOG=error,force=info RUST_TRACEBACK=1 force-eth-cli dapp server --config-path ./config.toml --ckb-private-key-path ${CKB_MINT_PRIVKY}  --listen-url 0.0.0.0:3003 --db-path ${DB_PATH}
}
ckb-indexer() {
 force-eth-cli dapp ckb-indexer --config-path ./config.toml --db-path ${DB_PATH} --ckb-rpc-url ${CKB_URL} --ckb-indexer-url ${INDEXER_URL}
}
eth-indexer() {
 cd /opt/force-bridge-eth/offchain-modules/
 force-eth-cli dapp eth-indexer --config-path /opt/config.toml --db-path ${DB_PATH} --ckb-indexer-url ${INDEXER_URL}
}
ckb-tx-relayer() {
 force-eth-cli dapp ckb-tx-relayer --config-path ./config.toml --db-path ${DB_PATH} -k ${ETH_UNLOCK_PRIVKEY}
}
eth-tx-relayer() {
 force-eth-cli dapp eth-tx-relayer --config-path ./config.toml --db-path ${DB_PATH} -p ${CKB_MINT_PRIVKY}
}
hello() {
 echo "hello world"
}
case $1 in
   ckb-header-relay)
      ckb-header-relay
      ;;
   eth-header-relay)
      eth-header-relay
      ;;
   force-server)
      force-server
      ;;
   ckb-indexer)
      ckb-indexer
      ;;
   eth-indexer)
      eth-indexer
      ;;
   ckb-tx-relayer)
      ckb-tx-relayer
      ;;
   eth-tx-relayer)
      eth-tx-relayer
      ;;
   *)
      hello
      ;;
esac
