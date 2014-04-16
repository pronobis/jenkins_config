#!/bin/bash
echo "Job name:    "$JOB_NAME
echo "Workspace:   "$WORKSPACE

# path to scripts directory
JOB_SCRIPTS_PATH=/var/lib/jenkins/jenkins_config/scripts

# update catkin ws
$JOB_SCRIPTS_PATH"/update_catkin_workspace.sh"

# NOTE: seems to work
# Cpplint
$JOB_SCRIPTS_PATH"/run_cpplint.bash" $WORKSPACE"/src"

# NOTE: seems to work
# Counting lines of code/comments
$JOB_SCRIPTS_PATH"/run_codecount.bash" $WORKSPACE"/src"

# NOTE: didn't finish in > 1hr.  So stopped
# CPP check
$JOB_SCRIPTS_PATH"/run_cppcheck.bash" $WORKSPACE"/src"

# # NOTE: there was no run_gcorv.bash
# # Coverage
# source $WORKSPACE"/../scripts/run_gcorv.bash" $WORKSPACE"/src"

# NOTE: below two need little bit of tunning.
# # build catkin ws
# $JOB_SCRIPTS_PATH"/clean_catkin_workspace.sh"

# build catkin ws
$JOB_SCRIPTS_PATH"/build_catkin_workspace.sh"

