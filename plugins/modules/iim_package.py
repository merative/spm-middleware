#!/usr/bin/python
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = '''
---
module: iim_package
version_added: "0.1.0"
short_description: Install/Update packages using IBM Installation Manager
description:
    - Install or update packages using IBM Installation Manager (must be installed using the "iim" role)
options:
    iim_path:
        type: path
        description:
            - Absolute path to an existing installation of IBM Installation Manager
        default: /opt/IBM/InstallationManager
    shared_resources:
        type: path
        description:
            - Absolute path to an existing location of the shared resources directory for IIM
        default: /opt/IBM/IMShared
    product_id:
        type: list
        elements: str
        description:
            - Product ID to be installed/updated/deleted.
            - May be product family, or a specific product ID instance (including FixPack details)
        required: true
    repos:
        type: list
        elements: str
        aliases: [ repo ]
        description:
            - List of repositories to include when installing the package(s) specified by C(product_id)
    path:
        type: path
        description:
            - Absolute path where the package should be installed
    preferences:
        type: dict
        description:
            - A dictionary to be passed to the installer as preferences flag
    properties:
        type: dict
        description:
            - A dictionary to be passed to the installer as properties flag
    state:
        type: str
        description:
            - Desired state of the package denoted by C(product_id)
        choices: [ absent, present ]
        default: present
author:
    - Andrey Zhereshchin (@andrey-zhereshchin)
'''

EXAMPLES = '''
---
- name: Install WebSphere Liberty
  iim_package:
    product_id: com.ibm.websphere.liberty.ND
    path: /opt/IBM/WebSphere/Liberty
    repo: /tmp/wlp-repo
'''

RETURN = '''
---
packages:
    type: list
    elements: str
    description: List of installed packages.
    returned: always
base_installed:
    type: str
    description: Indicator if the product is installed.
    returned: always
exact_installed:
    type: str
    description: Indicator if the exact version of the product is installed.
    returned: when supported
'''

import logging.config
import os
import re
import sys

from ansible.module_utils.basic import AnsibleModule
from ansible_collections.wh_spm.middleware.plugins.module_utils.iim import IIMAgent

logger = logging.getLogger(sys.argv[0])


def main():
    module = AnsibleModule(
        argument_spec=dict(
            iim_path=dict(default='/opt/IBM/InstallationManager', type='path'),
            shared_resources=dict(default='/opt/IBM/IMShared', type='path'),
            repos=dict(type='list', aliases=['repo'], elements='str'),
            product_id=dict(type='list', elements='str', required=True),
            path=dict(type='path'),
            preferences=dict(type='dict'),
            properties=dict(type='dict'),
            state=dict(default='present', choices=['absent', 'present'])
        ),
        supports_check_mode=False
    )

    iim = IIMAgent(module)

    # Process all arguments
    state = module.params['state']
    product_id = module.params['product_id']
    result = dict(changed=False)

    if state == 'absent':
        if iim.have_base_version(product_id[0]):
            result = iim.uninstall_package(product_id)
            module.exit_json(**result)
        else:
            module.exit_json(**result)

    if state == 'present' and (not iim.have_base_version(product_id[0]) or not iim.have_exact_version(product_id[0])):
        result = iim.install_package(product_id)
        module.exit_json(**result)

    module.fail_json('Should have exited cleanly by now ...', **result)


if __name__ == '__main__':
    main()
