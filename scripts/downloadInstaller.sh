#!/bin/bash
echo service is $1
# IIM
if [ "$1" = "iim-191-centos-8" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz
# Websphere
elif [ "$1" = "websphere-v85-centos-7" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz

elif [ "$1" = "websphere-v90-centos-8" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz


elif [ "$1" = "ihs-v90-centos-8" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz

elif [ "$1" = "ihs-v80-centos-7" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz
fi
