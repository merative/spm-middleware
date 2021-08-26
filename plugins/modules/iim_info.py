#!/usr/bin/python
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = '''
---
module: iim_info
version_added: "0.1.4"
short_description: List packages installed by IBM Installation Manager
description:
    - See what packages are installed by IBM Installation Manager.
    - If C(product_id) is provided, check if that specific package is installed.
options:
    iim_path:
        type: path
        description:
            - Absolute path to an existing installation of IBM Installation Manager
        default: /opt/IBM/InstallationManager
    product_id:
        type: list
        elements: str
        description:
            - May be product family, or a specific product ID instance (including FixPack details)
author:
    - Andrey Zhereshchin (@andrey-zhereshchin)
'''

EXAMPLES = '''
---
- name: Check packages
  iim_info:
    iim_path: /opt/IBM/InstallationManager
    product_id: com.ibm.websphere.liberty.ND
  register: iim_info

- name: Install Liberty base (GA) product
  include_tasks: base_install.yml
  when: not iim_info.base_installed
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
            product_id=dict(type='list', elements='str')
        ),
        supports_check_mode=False
    )

    iim = IIMAgent(module)

    product_id = module.params['product_id']

    result = dict(changed=False)
    result['packages'] = iim.list_installed_packages()

    if product_id is not None:
        result['base_installed'] = iim.have_base_version(product_id[0])
        result['exact_installed'] = iim.have_exact_version(product_id[0])

    module.exit_json(**result)


if __name__ == '__main__':
    main()
