#!/bin/bash

export SWI_HOME_DIR=/usr/local/swipl-git/lib/swipl/
export LD_LIBRARY_PATH=$SWI_HOME_DIR/lib/x86_64-linux/:$SWI_HOME_DIR/lib/amd64/:$LD_LIBRARY_PATH
export LD_PRELOAD=libswipl.so:$LD_PRELOAD

export SARL_VERSION=0.8.6

