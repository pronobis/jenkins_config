#!/bin/bash

# variables
JOB_NAME=$1
JENKINS_HOME=/var/lib/jenkins
SCRIPTS_PATH=${JENKINS_HOME}/jenkins_config/scripts
CONFIG_FILE_PATH=${JENKINS_HOME}/jenkins_config/jobs/template_job/config.xml
JOB_PATH=${JENKINS_HOME}/jobs/${JOB_NAME}
JENKINS_CLI=${JENKINS_HOME}/jenkins-cli.jar


if [ ! -d ${JOB_PATH} ];
then
	# creating job
	java -jar ${JENKINS_CLI} -s https://localhost:8080 create-job ${JOB_NAME} < ${CONFIG_FILE_PATH}
	java -jar ${JENKINS_CLI} -s https://localhost:8080 reload-configuration

	echo "Created new jenkins job $JOB_NAME"
fi


