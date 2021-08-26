from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import os
from re import match


class IIMAgent(object):

    def __init__(self, module):

        self._name = os.path.basename(__file__)

        self.module = module
        self.iim_path = self.module.params['iim_path']
        self.installed_packages = []

        # Check that iim_path is valid
        if not os.path.exists(self.iim_path):
            result = dict(changed=False, installed=False)
            self.module.fail_json('Specified IIM path {0} does not exist!'.format(self.iim_path), **result)

    def have_base_version(self, product_id):
        '''
        Check if a base version of the specified product is installed.
        '''

        base_product = product_id.split('_')[0]

        all_packages = self.list_installed_packages()
        filtered_packages = list(filter(lambda v: match(base_product + '.*', v), all_packages))

        return len(filtered_packages) > 0

    def have_exact_version(self, product_id, refresh=False):
        '''
        Check if the exact version of the specified product is installed.
        '''

        return product_id in self.list_installed_packages(refresh)

    def list_installed_packages(self, refresh=False):
        '''
        Return the list of installed packages.
        '''

        if len(self.installed_packages) == 0 or refresh:
            rc, stdout, stderr = self.module.run_command('{0}/eclipse/tools/imcl listInstalledPackages'.format(self.iim_path), check_rc=True)
            return stdout.strip().split('\n')
        else:
            return self.installed_packages

    def install_package(self, product_id):
        '''
        Install the specified package
        '''

        shared_resources = self.module.params['shared_resources']
        repos = self.module.params['repos']
        install_path = self.module.params['path']
        preferences = self.module.params['preferences']
        properties = self.module.params['properties']

        self.module.debug("Installing product ID '{0}' ...".format(product_id))

        command = '{0}/eclipse/tools/imcl install {1} -repositories {2} -sRD {3} -iD {4} -acceptLicense -showProgress'.format(
            self.iim_path, ' '.join(product_id), ','.join(repos), shared_resources, install_path
        )

        if preferences:
            prefs_string = ' -preferences '
            prefs_string += ','.join(['{0}={1}'.format(key, value) for key, value in preferences.items()])
            command += prefs_string

        if properties:
            props_string = ' -properties '
            props_string += ','.join(['{0}={1}'.format(key, value) for key, value in properties.items()])
            command += props_string

        self.module.run_command(command, check_rc=True)

        result = dict(
            changed=True,
            packages=self.list_installed_packages(),
            base_installed=self.have_base_version(product_id[0]),
            exact_installed=self.have_exact_version(product_id[0])
        )

        return result

    def uninstall_package(self, product_id):
        '''
        Uninstall specified package
        '''

        install_path = self.module.params['path']

        self.module.debug("Uninstalling product ID '{0}' ...".format(product_id))

        command = '{0}/eclipse/tools/imcl uninstall {1} -iD {2}'.format(self.iim_path, ' '.join(product_id), install_path)
        self.module.run_command(command, check_rc=True)

        result = dict(
            changed=True,
            packages=self.list_installed_packages(),
            base_installed=False,
            exact_installed=False
        )

        return result
