#!/bin/bash

echo "Job name:    "$JOB_NAME
echo "Workspace:   "$WORKSPACE

# Path to scripts directory
JOB_SCRIPTS_PATH=/var/lib/jenkins/jenkins_config/scripts

# Run all scripts
$JOB_SCRIPTS_PATH"/remove_catkin_workspace.sh" &&
$JOB_SCRIPTS_PATH"/create_catkin_workspace.sh" &&
$JOB_SCRIPTS_PATH"/run_cpplint.bash" $WORKSPACE"/src" &&
$JOB_SCRIPTS_PATH"/run_codecount.bash" $WORKSPACE"/src" &&
$JOB_SCRIPTS_PATH"/build_catkin_workspace.sh" &&
$JOB_SCRIPTS_PATH"/run_tests.sh" &&
$JOB_SCRIPTS_PATH"/send_to_robot.sh" &&
$JOB_SCRIPTS_PATH"/say_done.sh"
