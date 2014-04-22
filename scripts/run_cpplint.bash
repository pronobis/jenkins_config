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

	echo -e "Examining path: "$ROS_PATH
	python ${SCRIPTS_PATH}/cpplint.py --linelength=100 `find $ROS_PATH -regex '.*\.\(cpp\|h\|cc\|hh\)' | grep -v "${grepstr}"` 2> ${WORKSPACE}/cpplint_warnings_absolute.txt

	### Ignore new-line curly brace warnings.
	grep -v '{ should almost always be at the end of the previous line' ${WORKSPACE}/cpplint_warnings_absolute.txt > ${WORKSPACE}/cpplint_filter1.txt

	### Ignore new-line else warnings.
	grep -v 'An else should appear on the same line as the preceding }' ${WORKSPACE}/cpplint_filter1.txt > ${WORKSPACE}/cpplint_filter2.txt

        ### Indentation before public/private/protected
	grep -v 'should be indented +1 space inside' ${WORKSPACE}/cpplint_filter2.txt > ${WORKSPACE}/cpplint_filter3.txt

        ### Do not leave a blank line after public/private/protected
	grep -v 'Do not leave a blank line after' ${WORKSPACE}/cpplint_filter3.txt > ${WORKSPACE}/cpplint_filter4.txt
        
	### Make all paths relative so jenkins can find them.
	sed 's/\/var\/lib\/jenkins\/jobs\/${JOB_NAME}\/workspace\///g' ${WORKSPACE}/cpplint_filter4.txt >> ${WORKSPACE}/cpplint.txt
	
done

# Make all paths relative so jenkins can find them.
echo -e "Changing Cpplint absolute paths to relative for Jenkins"
sed "s:"$WORKSPACE"/src:src:g" ${WORKSPACE}/cpplint.txt > ${WORKSPACE}/cpplint_warnings.txt

#clenup
rm ${WORKSPACE}/cpplint_warnings_absolute.txt
rm ${WORKSPACE}/cpplint_filter1.txt
rm ${WORKSPACE}/cpplint_filter2.txt
rm ${WORKSPACE}/cpplint.txt

echo "Done!"

