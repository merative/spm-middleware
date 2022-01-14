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

## Ansible installation instructions

### Prerequisites
 - brew and python3 - See [PythonDocs](https://docs.python-guide.org/starting/install3/osx/) (OSX instructions) for help installing these
 - Access to Artifactory and a personal Artifactory API token or
 - A file server or similar to host the downloaded installers e.g. Artifactory, Python Simple HTTP Server
 - You will also need to download the roles from Ansible Galaxy
 `export ANSIBLE_COLLECTIONS_PATHS=.`
 `ansible-galaxy collection install -c -s https://galaxy.ansible.com -p . ibm.spm_toolbox`
 `ansible-galaxy collection install -c -s https://galaxy.ansible.com -p . ibm.spm_middleware`

### Setup Ansible
1. Create a virtual environment to use with ansible (FYI you can use a virtual environment across your ansible projects or use a dedicated one per project) `python3 -m venv ~/virtual_environments/ansible_venv`
2. Activate the virtual environment. `~/virtual_environments/ansible_venv/bin/activate`

```
pip3 install -U pip
pip3 install ansible
```

## Sample Usage

The following is a simple sample playbook that could be used to install the middleware required to deploy as SPM application. The sample is the "Blue stack" with IIM, Websphere and DB2 installed (Note IIM is required for the WAS role and is included by default). This example downloads the required installed from an Artifactory server. Update the `download_url` and `download_header` details to download the installers from a different location.

An example of how to run this playbook is included below.

```
- name: Install Middleware and prerequisites for an SPM Deployment
  hosts: servers
  remote_user: root
  vars:
    ansible_python_interpreter: /usr/bin/python3
    download_url: "{{ lookup('env', 'ARTIFACTORY_URL') }}/{{ lookup('env', 'ARTIFACTORY_REPO') }}"
    download_header: { 'X-JFrog-Art-Api': "{{ lookup('env', 'ARTIFACTORY_PSW') }}"}

  collections:
    - ibm.spm_toolbox
    - ibm.spm_middleware  

  roles:
    - role: iim
    - role: nodejs

  tasks:
    - name: Install Apache Ant
      include_role:
        name: ant
      vars:
        download_url: https://archive.apache.org/dist/ant/binaries

    - name: Install Jfrog
      include_role:
        name: jfrog

    - name: Install DB2
      include_role:
        name: db2
      when: db2_version is defined
      vars:
        db2_db_username: db2admin
        db2_db_password: '<A DB2 Admin Password>'
        db2_db_spm_enc: '<An encypted DB2 Admin Password>'

    - name: Install Websphere
      include_role:
        name: websphere
      when: websphere_version is defined

```

### Setting up a hosts file
Before you can call the playbook you can create a hosts file that will list the FQDNs for the machine(s) you want to run the playbook on. The following is an example of what a hosts file looks like. Note the `servers` group is specified in the playbook as part of the `hosts:` declaration.

```
[servers]
myserver1.fyre.ibm.com
myserver2.fyre.ibm.com
```

You can call the above sample playbook like this (passing in the requisite versions). The `-i` is used to point to the hosts file we created above ("i" is for inventory).

```
 ansible-playbook -i hosts ./myplaybook.yml \
   -e download_url '<DB2 installer location>' \
   -e download_header'<Download header>' \
   -e db2_version '<DB2 version>' \
   -e websphere_version '<WAS version>'
```

Note if you want to run your playbook on a single host you can input the FQDN where the hosts file is specified as follows:

```
 ansible-playbook -i myserver1.fyre.ibm.com ./myplaybook.yml \
   -e download_url '<DB2 installer location>' \
   -e download_header'<Download header>' \
   -e db2_version '<DB2 version>' \
   -e websphere_version '<WAS version>'
```

For Example:
```
ansible-playbook -i testdocs1.fyre.ibm.com ./myplaybook.yml \
   -e download_url: "{{ lookup('env', 'ARTIFACTORY_URL') }}/{{ lookup('env', 'ARTIFACTORY_REPO') }}" \
   -e download_header: { 'X-JFrog-Art-Api': "{{ lookup('env', 'ARTIFACTORY_PSW') }}"} \
   -e db2_version '11.1.4.6' \
   -e websphere_version '9.0.5.8'
```

If it suits your use case you can include the vars in the hosts file also. In that case calling the playbook can be simplified and the hosts file looks like this. Examples below:

```
[servers]
myserver1.fyre.ibm.com
myserver2.fyre.ibm.com

[servers:vars]
download_url = '<DB2 installer location>'
download_header = '<Download header>'
db2_version = '<DB2 version>'
websphere_version = '<WAS version>'
```

If you use the approach above your playbook can be called as follows.

```
ansible-playbook -i hosts ./myplaybook.yml
```

**Note:** Which of these options to use is entirely a matter of your usage scenario and/or personal preference.

### Useful links

* https://docs.ansible.com/ansible/devel/dev_guide/developing_collections.html
