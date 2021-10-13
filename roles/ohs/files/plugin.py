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

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type
import sys


def usage():
    print('Usage:')
    print('\twlst.sh -i plugin.py [AdminUsername] [AdminPassword] [AdminPort] [ServerName]')
    print('\twlst.sh -i plugin.py weblogic Password1 7001 CuramServer')
    print('')


def enable_plugin(admin_username, admin_password, admin_port='7001', server_name='CuramServer'):
    connect(admin_username, admin_password, 't3://localhost:%s' % (admin_port))
    edit()
    startEdit()
    cd('//Servers/%s' % (server_name))
    cmo.setWeblogicPluginEnabled(true)
    cd('//Servers/%s/SSL/%s' % (server_name, server_name))
    cmo.setTwoWaySSLEnabled(true)
    cmo.setClientCertificateEnforced(false)
    save()
    activate(block='true')
    disconnect()
    exit()


if len(sys.argv) < 5:
    usage()
    sys.exit(1)


admin_username = str(sys.argv[1])
admin_password = str(sys.argv[2])
admin_port = str(sys.argv[3])
server_name = str(sys.argv[4])

print('Enabling plugin on server "%s" via port %s' % (server_name, admin_port))

enable_plugin(admin_username, admin_password, admin_port, server_name)
