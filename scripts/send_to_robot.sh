#!/bin/bash

echo
echo "============================================================================"
echo "Syncing the robot branch with the master branch"
echo "============================================================================"

# Enter the workspace
cd ${WORKSPACE}/src

# Gathering repo info
repo_list=`wstool info --only=path,scmtype`
for line in $repo_list; do

    repo=(${line//,/ })
    path=${repo[0]}
    type=${repo[1]}
    echo "-> Syncing ${path/*\//}"

    if [ $type ] 
    then

	# git repository
	if [ $type == "git" ]
	then

	    # Enter path
	    cd $path

	    # Merge
	    git checkout robot
	    git pull
	    git merge master
	    git push
	    git checkout master

	fi

    # Unknown repo type
    else

	echo "Error: Unknown repo type!"
	exit -1

    fi

    # New line
    echo

done
