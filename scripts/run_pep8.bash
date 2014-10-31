#!/bin/bash

# Pep8

# Variables
SCRIPTS_PATH=${JENKINS_HOME}/jenkins_config/scripts
IGNORE_PATH=${JENKINS_HOME}/jenkins_config/lint_ignore

echo
echo "================================================================="
echo "Executing Pep8"
echo "================================================================="

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
  # Apply linting to files with python extentions
  find . -iname "*.py"
  find . -iname "*.py" -exec pep8 --max-line-length=120 '{}' \; > ${WORKSPACE}/pep8_warnings_absolute.txt
  # Apply linting to files with python shebang line
  grep -rl '^#!/.*python' . | grep -v .py
  grep -rl '^#!/.*python' . | grep -v .py | xargs pep8 --max-line-length=120 >> ${WORKSPACE}/pep8_warnings_absolute.txt

  # Make all paths relative so jenkins can find them.
  echo -e "Changing all paths so jenkins can find them"
  sed 's/\.\//src\//g' ${WORKSPACE}/pep8_warnings_absolute.txt >> ${WORKSPACE}/pep8.txt
done

cp ${WORKSPACE}/pep8.txt ${WORKSPACE}/pep8_warnings.txt

# Clenup
rm ${WORKSPACE}/pep8_warnings_absolute.txt
rm ${WORKSPACE}/pep8.txt

echo "Done!"

