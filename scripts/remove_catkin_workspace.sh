#!/bin/bash

# variables
CMAKELISTS_FILE=$WORKSPACE"/src/CMakeLists.txt"
DEVEL_DIR=$WORKSPACE"/devel"
INSTALL_DIR=$WORKSPACE"/install"
SRC_DIR=$WORKSPACE"/src"

echo
echo "============================================================================"
echo "Removing catkin workspace"
echo "============================================================================"

# placing all items into array
items="$CMAKELISTS_FILE $DEVEL_DIR $INSTALL_DIR $SRC_DIR"

# removing files and directories
for item in $items;
do

	echo "- Checking $item"
	if [ -f $item ];
	then
		rm -R $item
		echo "- Removed $item"
	fi

	if [ -d $item ];
	then
		rm -R $item
		echo "- Removed $item"
	fi

done
