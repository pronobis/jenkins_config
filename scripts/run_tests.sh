#!/bin/bash

# variables
ROS_SETUP_FILE="/opt/ros/hydro/setup.bash"

# sourcing setup file
source $ROS_SETUP_FILE

echo
echo
echo "============================================================================"
echo "Running tests"
echo "============================================================================"
catkin_make run_tests

