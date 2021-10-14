# coding=utf-8
###############################################################################
# Copyright 2020 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

import sys


def usage():
    print('Usage:')
    print('\twlst.sh -i configOHS.py [OracleHome] [OHSDomain] [FQDN] [AdminUsername] [AdminPassword] [OHSTemplateJar]')
    print('\twlst.sh -i configOHS.py $OHS_HOME "ohs_$(hostname -s)" $(hostname -f) weblogic Password1 ohs_standalone_template.jar')
    print('')


def create_ohs_domain(oracle_home, local_domain, fqdn, admin_username, admin_password, template_jar='ohs_standalone_template.jar'):
    readTemplate('%s/wlserver/common/templates/wls/base_standalone.jar' % (oracle_home))
    addTemplate('%s/ohs/common/templates/wls/%s' % (oracle_home, template_jar))
    cd('/')
    create(local_domain, 'SecurityConfiguration')
    cd('SecurityConfiguration/%s' % (local_domain))
    set('NodeManagerUsername', admin_username)
    set('NodeManagerPasswordEncrypted', admin_password)
    setOption('NodeManagerType', 'PerDomainNodeManager')
    setOption('JavaHome', '%s/oracle_common/jdk' % (oracle_home))
    cd('/Machines/localmachine/NodeManager/localmachine')
    cmo.setListenAddress('localhost')
    cmo.setListenPort(5556)
    cmo.setNMType('SSL')
    cd('/OHS/ohs1')
    cmo.setListenPort('80')
    cmo.setSSLListenPort('443')
    cmo.setServerName('http://%s' % (fqdn))
    writeDomain('%s/user_projects/domains/%s'  % (oracle_home, local_domain))
    exit()


if len(sys.argv) < 6:
    usage()
    sys.exit(1)


oracle_home = str(sys.argv[1])
local_domain = str(sys.argv[2])
fqdn = str(sys.argv[3])
admin_username = str(sys.argv[4])
admin_password = str(sys.argv[5])

print('Oracle Home: %s' % (oracle_home))
print('Creating Domain "%s" ...' % (local_domain))


if len(sys.argv) == 7:
    template_jar = str(sys.argv[6])
    create_ohs_domain(oracle_home, local_domain, fqdn, admin_username, admin_password, template_jar)
else:
    create_ohs_domain(oracle_home, local_domain, fqdn, admin_username, admin_password)
