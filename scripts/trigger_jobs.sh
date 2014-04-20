#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:$PATH

# variables
JENKINS_HOME=/var/lib/jenkins
SCRIPTS_PATH=${JENKINS_HOME}/jenkins_config/scripts
JENKINS_CLI=${JENKINS_HOME}/jenkins-cli.jar
export JENKINS_CMD="java -jar "${JENKINS_CLI}" -s https://localhost:8080"

echo
echo "============================================================================"
echo "Updating jenkins_config repository"
echo "============================================================================"
cd ${JENKINS_HOME}/jenkins_config && git pull #&>/dev/null
chmod a+rwx -R ${SCRIPTS_PATH}

if [ ! -f $JENKINS_CLI ];
then
	echo "downloading jenkins-cli.jar"
	cd ${JENKINS_HOME}
	wget --secure-protocol=SSLv3 --no-check-certificate https://localhost:8080/jnlpJars/jenkins-cli.jar
	chmod a+rwx ${JENKINS_CLI}
fi

# install required jenkins plugins
${SCRIPTS_PATH}/install_plugins.sh

echo
echo "============================================================================"
echo "Creating Jenkins jobs"
echo "============================================================================"
for F in ${JENKINS_HOME}/jenkins_config/workspaces/*; do
	
	if [ "${F##*~}" == "" ];
	then
		echo "Temporary file found: $F, skipping"
		continue
	fi

	file_name=${F##*/}
	job_name=${F%.rosinstall}
	job_name=${job_name##*/}
	echo "Found job $job_name with file $file_name"
	${SCRIPTS_PATH}/create_jenkins_job.sh $job_name
done

echo
echo "============================================================================"
echo "Initializing/triggering jobs"
echo "============================================================================"
for D in ${JENKINS_HOME}/jobs/*; do
	echo "=== Job found in directory $D ==="
	crumbs=(${D//\// })
	job=${crumbs[${#crumbs[@]} - 1]}
	status=`$SCRIPTS_PATH/check_workspace_status.sh $D/workspace $job`
	if [ $status == "behind" ];
	then
	    echo "Triggering $job"
	    java -jar ${JENKINS_CLI} -s https://localhost:8080 build $job
	else
	    echo "$job is up to date"
	fi
done

