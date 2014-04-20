#!/bin/bash

# variables
ROS_SETUP_FILE="/opt/ros/hydro/setup.bash"

echo
echo "============================================================================"
echo "Building catkin workspace"
echo "============================================================================"

source $ROS_SETUP_FILE
catkin_make
