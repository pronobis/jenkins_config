#!/bin/bash

# variables
ROS_SETUP_FILE="/opt/ros/hydro/setup.bash"
ROS_INSTALL_FILE=${JENKINS_HOME}/jenkins_config/workspaces/${JOB_NAME}.rosinstall

echo
echo "============================================================================"
echo "Creating the catkin workspace"
echo "============================================================================"

echo "Initializing workspace:"
mkdir -p "${WORKSPACE}"
cd ${WORKSPACE}
wstool init ${WORKSPACE}/src
cd ${WORKSPACE}/src
wstool merge ${ROS_INSTALL_FILE}

echo
echo "Cloning repositories:"
cd ${WORKSPACE}/src
wstool update -v -j20
