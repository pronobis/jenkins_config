#!/bin/bash

# variables
ROS_SETUP_FILE="/opt/ros/hydro/setup.bash"
IGNORE_PATH=${JENKINS_HOME}/jenkins_config/catkin_make_ignore

echo
echo "============================================================================"
echo "Building catkin workspace"
echo "============================================================================"

# Read the ignore file
ignorestr=""
while read p; do
  echo "Ignoring $p"

  if [ "$grepstr" == "" ]
  then
      ignorestr="$p"
  else
      ignorestr="${ignorestr};$p"
  fi
done < $IGNORE_PATH
echo

source $ROS_SETUP_FILE
catkin_make -DCATKIN_BLACKLIST_PACKAGES="${ignorestr}"
