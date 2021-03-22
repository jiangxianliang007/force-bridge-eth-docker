#!/bin/bash
set -e

export RUST_BACKTRACE=1
export RUST_LOG=warn,force=info,actix_web=info

DB_NAME=forcedb
DB_PATH=mysql://root:root@127.0.0.1:3306/${DB_NAME}
HEADER_RELAY_PRIVKEY=1
CKB_MINT_PRIVKY=2
ETH_UNLOCK_PRIVKEY=2
API_SERVER_PRIVKEY="4 5"
HEADER_RELAYER_CKB_ROCKSDB_PATH=/opt/rocksdb/ckb_rocksdb
HEADER_RELAYER_ETH_ROCKSDB_PATH=/opt/rocksdb/eth_rocksdb

HEADER_INDEXER_CKB_ROCKSDB_PATH=/opt/rocksdb/ckb_indexer_rocksdb
HEADER_INDEXER_ETH_ROCKSDB_PATH=/opt/rocksdb/eth_indexer_rocksdb
ETH_MERKLE_ROCKSDB_PATH=/opt/rocksdb/merkle_rocksdb

cd /opt/force-bridge-eth/offchain-modules/

ckb-header-relay() {
 force-eth-cli ckb-relay --config-path /opt/config.toml -k ${HEADER_RELAY_PRIVKEY} --per-amount 10  --max-tx-count 10 --mutlisig-privkeys  0 > /opt/logs/ckb-header-relay.log 2>&1
}
eth-header-relay() {
 force-eth-cli eth-relay --config-path /opt/config.toml -k ${HEADER_RELAY_PRIVKEY} --multisig-privkeys 1 > /opt/logs/eth-header-relay.log 2>&1
}
force-server() {
 force-eth-cli dapp server --config-path /opt/config.toml --server-private-key-path ${API_SERVER_PRIVKEY} --mint-private-key-path ${CKB_MINT_PRIVKY} --listen-url 0.0.0.0:3003 --db-path ${DB_PATH} > /opt/logs/force-server.log 2>&1
}
ckb-indexer() {
 force-eth-cli dapp ckb-indexer --config-path /opt/config.toml --db-path ${DB_PATH}  > /opt/logs/ckb-indexer.log 2>&1
}
eth-indexer() {
 force-eth-cli dapp eth-indexer --config-path /opt/config.toml --db-path ${DB_PATH}  > /opt/logs/eth-indexer.log 2>&1
}
ckb-tx-relayer() {
 force-eth-cli dapp ckb-tx-relayer --config-path /opt/config.toml --db-path ${DB_PATH} -k ${ETH_UNLOCK_PRIVKEY} --rocksdb-path ${HEADER_INDEXER_CKB_ROCKSDB_PATH}  > /opt/logs/ckb-tx-relayer.log 2>&1
}
eth-tx-relayer() {
 force-eth-cli dapp eth-tx-relayer --config-path /opt/config.toml --db-path ${DB_PATH} -p ${CKB_MINT_PRIVKY} --rocksdb-path ${HEADER_INDEXER_ETH_ROCKSDB_PATH} > /opt/logs/eth-tx-relayer.log 2>&1
}
eth-header-indexer() {
 force-eth-cli dapp eth-header-indexer --config-path /opt/config.toml --rocksdb-path ${HEADER_INDEXER_ETH_ROCKSDB_PATH} --merkle-path ${ETH_MERKLE_ROCKSDB_PATH}  > /opt/logs/eth-header-indexer.log 2>&1
}
ckb-header-indexer() {
 force-eth-cli dapp ckb-header-indexer --config-path /opt/config.toml --rocksdb-path ${HEADER_INDEXER_CKB_ROCKSDB_PATH} > /opt/logs/ckb-header-indexer.log 2>&1
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
   ckb-header-indexer)
      ckb-header-indexer
      ;;
   eth-header-indexer)
      eth-header-indexer
      ;;
   *)
      hello
      ;;
esac