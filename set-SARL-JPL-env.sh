#!/bin/bash
###############################################################
# Sets up the environment to use SWIPL + JPL in /usr/local
#
# Options are 
#
#	local: local install in /usr/local/swipl-git
#	devel: install at $HOME/git/soft/prolog/swipl-devel.git
#	dist: the one installed by the distribution
##############################################################

##### GET OPTIONS FROM COMMAND-LINE
NO_ARGS=$#   # Get the number of arguments passed in the command line

MY_NAME=${0##*/} 

#echo
#echo "# arguments called with ---->  ${@}     "
#echo "# \$1 ---------------------->  $1       "
#echo "# \$2 ---------------------->  $2       "
#echo "# path to me --------------->  ${0}     "
#echo "# parent path -------------->  ${0%/*}  "
#echo "# my name ------------------>  ${0##*/} "
#echo
#exit

if [[ $NO_ARGS -ge 1 ]]; then
    case $1 in

        unset)
	        # For Linux-based dist install
		# Use LOCAL INSTALL of SWIPL at /usr/local/swipl-git/
		unset SWI_HOME_DIR SWIPL_BOOT_FILE SWIPL_EXEC_FILE LD_LIBRARY_PATH LD_PRELOAD CLASSPATH
        	echo "Unset all JPL variables"
            ;;
        local)
		# Use LOCAL INSTALL of SWIPL at /usr/local/swipl-git/
		export SWI_HOME_DIR=/usr/local/swipl-git/lib/swipl
		export SWIPL_BOOT_FILE=$SWI_HOME_DIR/lib/swipl/boot.prc
		export SWIPL_EXEC_FILE=$SWI_HOME_DIR/lib/swipl/bin/x86_64-linux/swipl
		export LD_LIBRARY_PATH=$SWI_HOME_DIR/lib/x86_64-linux/:$LD_LIBRARRY_PATH
		export LD_PRELOAD=$SWI_HOME_DIR/lib/x86_64-linux/libswipl.so
		export CLASSPATH=$SWI_HOME_DIR/lib/swipl/lib/jpl.jar:$CLASSPATH
	        echo "Set SWI to the LOCAL compiled version in $SWI_HOME_DIR"
            ;;
        dev)
		# Use development tree (not yet installed)
		export SWI_HOME_DIR=/home/ssardina/git/soft/prolog/swipl-devel.git/build/home
		export SWIPL_BOOT_FILE=$SWI_HOME_DIR/boot.prc
		export SWI_EXEC_FILE=$SWI_HOME_DIR/../src/swipl
		export LD_LIBRARY_PATH=$SWI_HOME_DIR/../packages/jpl
		export LD_PRELOAD=$SWI_HOME_DIR/../src/libswipl.so
		export CLASSPATH=$SWI_HOME_DIR/../../packages/jpl/out/artifacts/jpl_jar/:$SWI_HOME_DIR/../packages/jpl:/usr/lib/jvm/java-10-oracle/lib/server/libjvm.so
	        echo "Set SWI to the DEVELOPMENT TREE IN $SWI_HOME_DIR"
            ;;
	
    esac
else
    echo "choose between: dist local dev unset"
fi




# Set SARL VERSION
export SARL_VERSION=0.10.0
