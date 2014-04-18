#!/bin/bash
# merge new entries in workspace (.rosinstall) file and update all tracked repos

# variables
ROS_SETUP_FILE="/opt/ros/hydro/setup.bash"
SETUP_FILE=$WORKSPACE"/devel/setup.bash"
CMAKELISTS_FILE=$WORKSPACE"/src/CMakeLists.txt"
DEVEL_DIR=$WORKSPACE"/devel"
BUILD_DIR=$WORKSPACE"/build"

# placing all items into array
items="$CMAKELISTS_FILE $DEVEL_DIR $BUILD_DIR"

# removing files and directories
for item in $items;
do

	echo "- checking $item"
	if [ -f $item ];
	then
		rm -R $item
		echo "- removed $item"
	fi

	if [ -d $item ];
	then
		rm -R $item
		echo "- removed $item"
	fi

	echo "- done with $item"

done


# creating new cmakelist file
source $ROS_SETUP_FILE
# source $SETUP_FILE

cd $WORKSPACE"/src"
capture_stdout=$(catkin_init_workspace)



