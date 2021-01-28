#!/bin/bash
set -e

DB_NAME=forcedb
DB_PATH=mysql://root:root@127.0.0.1:3306/${DB_NAME}
HEADER_RELAY_PRIVKEY=1
CKB_MINT_PRIVKY=2
ETH_UNLOCK_PRIVKEY=2

cd /opt/

ckb-header-relay() {
 force-eth-cli ckb-relay --config-path ./config.toml -k ${HEADER_RELAY_PRIVKEY} --per-amount 10  --max-tx-count 10 --mutlisig-privkeys  0
}
eth-header-relay() {
 force-eth-cli eth-relay --config-path ./config.toml -k ${HEADER_RELAY_PRIVKEY} --multisig-privkeys 1
}
force-server() {
  RUST_LOG=error,force=info RUST_TRACEBACK=1 force-eth-cli dapp server --config-path ./config.toml --ckb-private-key-path ${CKB_MINT_PRIVKY}  --listen-url 0.0.0.0:3003 --db-path ${DB_PATH}
}
ckb-indexer() {
 force-eth-cli dapp ckb-indexer --config-path ./config.toml -db-path ${DB_PATH}
}
eth-indexer() {
 force-eth-cli dapp eth-indexer --config-path ./config.toml -db-path ${DB_PATH}
}
ckb-tx-relayer() {
 force-eth-cli dapp ckb-tx-relayer --config-path ./config.toml -db-path ${DB_PATH} -k ${ETH_UNLOCK_PRIVKEY}
}
eth-tx-relayer() {
 force-eth-cli dapp ckb-tx-relayer --config-path ./config.toml -db-path ${DB_PATH} -k ${CKB_MINT_PRIVKY}
}

case $1 in
   ckb-header-relayy)
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
      force-server
      ;;
esac
