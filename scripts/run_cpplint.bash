#!/bin/bash
# Cpplint

# variables
SCRIPTS_PATH=${JENKINS_HOME}/jenkins_config/scripts
IGNORE_PATH=${JENKINS_HOME}/jenkins_config/cpplint_ignore

echo
echo "============================================================================"
echo "Executing Cpplint"
echo "============================================================================"

# Read the ignore file
grepstr=""
while read p; do
  echo "Ignoring $p"

  if [ "$grepstr" == "" ]
  then
      grepstr="$p"
  else
      grepstr="${grepstr}\|$p"
  fi
done < $IGNORE_PATH
echo

for ROS_PATH in  "$@";
do
        cd ${ROS_PATH}

	echo -e "Examining following files in path: "$ROS_PATH
        find . -regex '.*\.\(cpp\|h\|cc\|hh\)' | grep -v "${grepstr}"
	${SCRIPTS_PATH}/cpplint `find . -regex '.*\.\(cpp\|h\|cc\|hh\)' | grep -v "${grepstr}"` 2> ${WORKSPACE}/cpplint_warnings_absolute.txt
        
	### Make all paths relative so jenkins can find them.
        echo -e "Changing all paths so jenkins can find them"
        sed 's/\.\//src\//g' ${WORKSPACE}/cpplint_warnings_absolute.txt >> ${WORKSPACE}/cpplint.txt

	
done

cp ${WORKSPACE}/cpplint.txt ${WORKSPACE}/cpplint_warnings.txt

#clenup
rm ${WORKSPACE}/cpplint_warnings_absolute.txt
rm ${WORKSPACE}/cpplint.txt

echo "Done!"

