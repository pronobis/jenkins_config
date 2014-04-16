#!/bin/bash

# variables
ROS_SETUP_FILE="/opt/ros/hydro/setup.bash"
SETUP_FILE=$WORKSPACE"/devel/setup.bash"

#sourcing setup file
echo "sourcing workspace setup script"
source $ROS_SETUP_FILE
source $SETUP_FILE

echo "============ Building catkin workspace ============"
# catkin_make clean
catkin_make
# catkin_make run_tests


