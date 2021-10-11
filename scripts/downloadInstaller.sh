#!/bin/bash
echo service is $1
# DB2
if [ "$1" = "default" ]; then
  echo db2111
  mkdir -p /tmp/db2/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/DB2/11.1/v11.1.4fp6_linuxx64_universal_fixpack.tar.gz -o /tmp/db2/db2_installer.tar.gz
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/DB2/11.1/db2ese_u.lic -o /tmp/db2ese_u.lic
elif [ "$1" = "db2-111-centos-7" ]; then
  echo db2111
  mkdir -p /tmp/db2/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/DB2/11.1/v11.1.4fp6_linuxx64_universal_fixpack.tar.gz -o /tmp/db2/db2_installer.tar.gz
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/DB2/11.1/db2ese_u.lic -o /tmp/db2ese_u.lic
elif [ "$1" = "db2-115-centos-8" ]; then
  echo db2115
  mkdir -p /tmp/db2/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/DB2/11.5/v11.5.5fp0_linuxx64_universal_fixpack.tar.gz -o /tmp/db2/db2_installer.tar.gz
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/DB2/11.5/db2ese_u.lic -o /tmp/db2ese_u.lic
fi

# IIM
if [ "$1" = "iim-191-centos-8" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz
fi

# Websphere
if [ "$1" = "websphere-v85-centos-7" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz

  echo "Download Websphere installer and fixpacks"
  # base
  mkdir -p /tmp/repo-zips/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5ND/WAS_ND_V8.5.5_1_OF_3.zip -o /tmp/repo-zips/WAS_ND_V8.5.5_1_OF_3.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5ND/WAS_ND_V8.5.5_2_OF_3.zip -o /tmp/repo-zips/WAS_ND_V8.5.5_2_OF_3.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5ND/WAS_ND_V8.5.5_3_OF_3.zip -o /tmp/repo-zips/WAS_ND_V8.5.5_3_OF_3.zip
  # fixpacks
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5Fixpacks/FP17/8.5.5-WS-WAS-FP017-part1.zip -o /tmp/repo-zips/8.5.5-WS-WAS-FP017-part1.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5Fixpacks/FP17/8.5.5-WS-WAS-FP017-part2.zip -o /tmp/repo-zips/8.5.5-WS-WAS-FP017-part2.zip
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/8.5.5Fixpacks/FP17/8.5.5-WS-WAS-FP017-part3.zip -o /tmp/repo-zips/8.5.5-WS-WAS-FP017-part3.zip

elif [ "$1" = "websphere-v90-centos-8" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz

  echo "Download Websphere installer and fixpacks"
  mkdir -p /tmp/repo-zips/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/9.0.5ND/was.repo.90500.nd.zip -o /tmp/repo-zips/was.repo.90500.nd.zip
  # java
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/Java/IBM/ibm-java-sdk-8.0-6.26-linux-x64-installmgr.zip -o /tmp/repo-zips/java-repo.zip
  # fixpacks
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/WAS/9.0.5Fixpacks/9.0.5-WS-WAS-FP008.zip -o /tmp/repo-zips/9.0.5-WS-WAS-FP008.zip

elif [ "$1" = "ihs-v90-centos-8" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz

elif [ "$1" = "ihs-v80-centos-7" ]; then
  echo "Download IIM installer"
  mkdir -p /tmp/iim/
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/IIM/agent.installer.linux.gtk.x86_64_1.9.1001.20191112_1525.zip -o /tmp/iim/iim_installer.tar.gz
fi
