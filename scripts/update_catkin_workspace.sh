#!/bin/bash
# merge new entries in workspace (.rosinstall) file and update all tracked repos

# variables
ROS_SETUP_FILE="/opt/ros/hydro/setup.bash"
SETUP_FILE=$WORKSPACE"/devel/setup.bash"
ROS_INSTALL_FILE=${JENKINS_HOME}/jenkins_config/workspaces/${JOB_NAME}.rosinstall

# merging workspace file
if [ -f $ROS_INSTALL_FILE ];
then
	# reset ros workspace file
	echo "" > "$WORKSPACE/src/.rosinstall"

	echo "updating workspace file $ROS_INSTALL_FILE"
	cd ${WORKSPACE}/src
    wstool merge ${ROS_INSTALL_FILE} -r -y
else
	echo "workspace .rosinstall file not found, skip update"
fi

#sourcing setup file
source $ROS_SETUP_FILE
source $SETUP_FILE

#updating repositories
echo "updating repositories"
wstool update --delete-changed-uris -v -j10

