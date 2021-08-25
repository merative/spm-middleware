#!/bin/bash
echo service is $1
if [ "$1" = "db2-115-centos-8" ]; then
  echo db2115
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/DB2/11.5/v11.5.5fp0_linuxx64_universal_fixpack.tar.gz -o /tmp/db2_installer.tar.gz
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/DB2/11.5/db2ese_u.lic -o /tmp/db2ese_u.lic
  ls -la /tmp/
elif [ "$1" = "db2111" ]; then
  echo db2111
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/DB2/11.1/v11.1.4fp5_linuxx64_universal_fixpack.tar.gz -o ${TRAVIS_BUILD_DIR}/db2/files/v11.1.4fp5_linuxx64_universal_fixpack.tar.gz
  ls -la ${TRAVIS_BUILD_DIR}/db2/files
elif [ "$1" = "db2105" ]; then
  echo db2105
  curl -H "X-JFrog-Art-Api: ${ARTIFACTORY_TOKEN}" -k ${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/SoftwareInstallers/DB2/10.5/v10.5fp10_linuxx64_universal_fixpack.tar.gz -o ${TRAVIS_BUILD_DIR}/db2/files/v10.5fp10_linuxx64_universal_fixpack.tar.gz
  ls -la ${TRAVIS_BUILD_DIR}/db2/files
fi
