#!/bin/bash

set -e

DATA_DIR=/solarcoin
CONF_FILE=$DATA_DIR/solarcoin.conf

# create configuration file on first run
if [ ! -e $CONF_FILE ]; then
	echo "addnode=162.243.214.120" >> $CONF_FILE
	echo "listen=1" >> $CONF_FILE
	echo "rpcuser=solarcoinrpc" >> $CONF_FILE
	perl -le 'print"rpcpassword=",map{(a..z,A..Z,0..9)[rand 62]}0..44' >> $CONF_FILE	
fi

exec "$@"

