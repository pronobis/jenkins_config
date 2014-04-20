#!/bin/bash

# variables
JENKINS_HOME=/var/lib/jenkins
SCRIPTS_PATH=${JENKINS_HOME}/jenkins_config/scripts
CATKIN_WORKSPACE=$1
JOB_NAME=$2
JOB_WORKSPACE_FILE=${JENKINS_HOME}/jenkins_config/workspaces/${JOB_NAME}.rosinstall
CATKIN_SETUP_FILE=${CATKIN_WORKSPACE}/devel/setup.bash

# check if setup file for catkin workspace exists
if [ -f $CATKIN_SETUP_FILE ];
then

	# entering workspace
	cd $1/src

	# merging workspace file
	if [ -f $JOB_WORKSPACE_FILE ];
	then
		capture_stdout=$(wstool merge ${JOB_WORKSPACE_FILE} -r -y)
	fi

	# gathering repo info
	repo_list=`wstool info --only=path,scmtype,version`
	for line in $repo_list; do

	  repo=(${line//,/ })
	  path=${repo[0]}
	  type=${repo[1]}
	  version=${repo[2]}

	  # check vcs type and inspect revision status
	  if [ $type ]; then

	    # git repository
	    if [ $type == "git" ]; then

	      # checking path first
	      if [ ! -d ${path} ];
	      then
		      echo behind
		      exit 0
	      fi

	      cd $path
	      if [ -z $version ]; then
		version="HEAD"
	      fi
	      git fetch &>/dev/null
	      behind=`git rev-list ${version}...origin/${version} --count`

	      if [[ $behind -ne 0 ]]; then
		echo behind
		exit 0
	      fi

            # svn repository
	    elif [ $type == "svn" ]; then
	      if [ -z $version ]; then
		cd $path
		behind=`svn diff -r HEAD`

		if [ ! -z "$behind" ]; then
		  echo behind
		  exit 0
		fi
	      fi
	    fi

	  fi

	done

else

	# initializing ros workspace
	mkdir -p "${CATKIN_WORKSPACE}"
	cd ${CATKIN_WORKSPACE} # entering job workspace
	capture_stdout=$(wstool init ${CATKIN_WORKSPACE}/src)
	cd ${CATKIN_WORKSPACE}/src
	capture_stdout=$(wstool merge ${JOB_WORKSPACE_FILE})

	# cloning all git repositories in src directory
	cd ${CATKIN_WORKSPACE}/src
	capture_stdout=$(wstool update -v -j20)

	echo behind
	exit 0

fi


echo synced
exit 0
