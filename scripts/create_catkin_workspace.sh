#!/bin/bash

# variables
WORKSPACE=$1
JOB_WORKSPACE_FILE=$2

# initializing ros workspace
mkdir -p "$WORKSPACE"
cd $WORKSPACE # entering job workspace
capture_stdout=$(wstool init ${WORKSPACE}/src)
cd $WORKSPACE/src
capture_stdout=$(wstool merge ${JOB_WORKSPACE_FILE})

# cloning all git repositories in src directory
cd $WORKSPACE/src
capture_stdout=$(wstool update -v -j10)



