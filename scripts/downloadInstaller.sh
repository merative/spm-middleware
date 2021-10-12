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

  echo "Download IHS installer and fixpacks"
  mkdir -p /tmp/repo-zips/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/9.0.5ND/was.repo.90500.ihs.zip -o /tmp/repo-zips/was.repo.90500.ihs.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/9.0.5ND/was.repo.90500.plugins.zip -o /tmp/repo-zips/was.repo.90500.plugins.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/9.0.5ND/was.repo.90500.wct.zip -o /tmp/repo-zips/was.repo.90500.wct.zip
  # java
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/Java/IBM/ibm-java-sdk-8.0-6.26-linux-x64-installmgr.zip -o /tmp/repo-zips/java-repo.zip

  # FP Plugins
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/9.0.5Fixpacks/9.0.5-WS-WCT-FP008.zip -o /tmp/repo-zips/9.0.5-WS-WCT-FP008.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/9.0.5Fixpacks/9.0.5-WS-IHSPLG-FP008.zip -o /tmp/repo-zips/9.0.5-WS-IHSPLG-FP008.zip


elif [ "$1" = "ihs-v80-centos-7" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz

  echo "Download IHS installer and fixpacks"
  mkdir -p /tmp/repo-zips/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5ND/WAS_V8.5.5_SUPPL_1_OF_3.zip -o /tmp/repo-zips/WAS_V8.5.5_SUPPL_1_OF_3.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5ND/WAS_V8.5.5_SUPPL_2_OF_3.zip -o /tmp/repo-zips/WAS_V8.5.5_SUPPL_2_OF_3.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5ND/WAS_V8.5.5_SUPPL_3_OF_3.zip -o /tmp/repo-zips/WAS_V8.5.5_SUPPL_3_OF_3.zip
  # fixpacks
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5Fixpacks/FP17/8.5.5-WS-WCT-FP017-part1.zip -o /tmp/repo-zips/8.5.5-WS-WCT-FP017-part1.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5Fixpacks/FP17/8.5.5-WS-WCT-FP017-part2.zip -o /tmp/repo-zips/8.5.5-WS-WCT-FP017-part2.zip

  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5Fixpacks/FP17/8.5.5-WS-WASSupplements-FP017-part1.zip -o /tmp/repo-zips/8.5.5-WS-WASSupplements-FP017-part1.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5Fixpacks/FP17/8.5.5-WS-WASSupplements-FP017-part2.zip -o /tmp/repo-zips/8.5.5-WS-WASSupplements-FP017-part2.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5Fixpacks/FP17/8.5.5-WS-WASSupplements-FP017-part3.zip -o /tmp/repo-zips/8.5.5-WS-WASSupplements-FP017-part3.zip
fi
