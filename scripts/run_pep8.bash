#!/bin/bash
# Pep8

# variables
SCRIPTS_PATH=${JENKINS_HOME}/jenkins_config/scripts
IGNORE_PATH=${JENKINS_HOME}/jenkins_config/cpplint_ignore

echo
echo "============================================================================"
echo "Executing Pep8"
echo "============================================================================"

for ROS_PATH in  "$@";
do
        cd ${ROS_PATH}

	echo -e "Examining following files in path: "$ROS_PATH
        find . -regex '.*\.\(cpp\|h\|cc\|hh\)' | grep -v "${grepstr}"
        find . -iname "*.py"
        find . -iname "*.py" -exec pep8 '{}' \; > ${WORKSPACE}/pep8_warnings_absolute.txt
        
	### Make all paths relative so jenkins can find them.
        echo -e "Changing all paths so jenkins can find them"
        sed 's/\.\//src\//g' ${WORKSPACE}/pep8_warnings_absolute.txt >> ${WORKSPACE}/pep8.txt

	
done

cp ${WORKSPACE}/pep8.txt ${WORKSPACE}/pep8_warnings.txt

#clenup
rm ${WORKSPACE}/pep8_warnings_absolute.txt
rm ${WORKSPACE}/pep8.txt

echo "Done!"

