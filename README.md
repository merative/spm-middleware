# Ansible Collection for SPM Middleware

A collection of Middleware modules and roles required for installing Cúram Social Program Management. **SUITABLE FOR INTERNAL TEST AND DEVELOPMENT ONLY**

* Entries in `galaxy.yml` should point to correct locations
* Molecule config and plays should point to correct collection
    - molecule/default/converge.yml

## Overview

Collections are a distribution format for Ansible content. You can use collections to package and distribute playbooks, roles, modules, and plugins.
You can publish and use collections through `Ansible Galaxy <https://galaxy.ansible.com/ibm>`.

Assumption for having collection as a repo, is it enable reuse of content as well, such repo can be easily used separately by just adding `ansible.cfg`.

## Collection structure

Collections follow a simple data structure. None of the directories are required unless you have specific content that belongs in one of them. A collection does require a ``galaxy.yml`` file at the root level of the collection. This file contains all of the metadata that Galaxy
and other tools need in order to package, build and publish the collection::

    collection/
    ├── docs/
    ├── galaxy.yml
    ├── plugins/
    │   ├── modules/
    │   │   └── module1.py
    │   ├── inventory/
    │   └── .../
    ├── README.md
    ├── roles/
    │   ├── role1/
    │   ├── role2/
    │   └── .../
    ├── playbooks/
    │   ├── files/
    │   ├── vars/
    │   ├── templates/
    │   └── tasks/
    └── tests/

### Useful links

* https://docs.ansible.com/ansible/devel/dev_guide/developing_collections.html
