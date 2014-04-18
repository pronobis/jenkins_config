#!/bin/bash
# CPP Check

#path to scripts directory
#JOB_SCRIPTS_PATH=${JENKINS_HOME}/jobs/${JOB_NAME}/scripts

echo "===== Performing CPP check ====="

if [ -f ${WORKSPACE}/cppcheck.xml ];
then
	echo "removing old cppcheck.xml file"
	rm ${WORKSPACE}/cppcheck.xml
    echo "done"
else
	echo "cppcheck.xml file not found, skipping deletion"
fi

for ROS_PATH in $@;
do
    echo "running cppcheck"
	cppcheck --enable=all -q --xml $ROS_PATH &>> ${WORKSPACE}/cppcheck.xml

done

#removing extra xml identifiers
sed -e '2,${/^<?xml/d}' -i ${WORKSPACE}/cppcheck.xml
sed -e '$ ! {/^<\/result/d}' -i ${WORKSPACE}/cppcheck.xml
sed -e '3,${/^<result/d}'  -i ${WORKSPACE}/cppcheck.xml

echo "===== Completed CPP check ====="
