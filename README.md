# Ansible Collection for SPM Middleware

A collection of Middleware modules and roles required for installing Cúram Social Program Management. **SUITABLE FOR INTERNAL TEST AND DEVELOPMENT ONLY**

* Entries in `galaxy.yml` should point to correct locations
* Molecule config and plays should point to correct collection
    - molecule/default/converge.yml

## Overview

Collections are a distribution format for Ansible content. You can use collections to package and distribute playbooks, roles, modules, and plugins.
You can publish and use collections through `Ansible Galaxy <https://galaxy.ansible.com/merative>`.

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

### Use Dev Container

If you have installed docker and VS Code on your machine, please add extension **Dev Containers** to VS Code, then you can use it to quickly setup your local development environment.

1. Add **.env** file under folder **.devcontainer** , you can put environment variables in it, these env vars will appear in the docker container. And **.env** has been put in the .gitignore, so you can put secrets in it, it will not be merge to github repo. Content of it:

```
ARTIFACTORY_URL=[artifactory url]
ARTIFACTORY_REPO=[repo contains software installer]
ARTIFACTORY_TOKEN=[token of artifactory]
LOCAL_PATH=/workspaces/spm-middleware
```
2. After the dev container starts, `postCreateCommand` automatically installs the Python packages from `requirements.txt` into a virtual environment at `/home/vscode/.venv` (which is on the `PATH`) and copies the ansible plugins for molecule tests. To redo this manually:

    ```
    mkdir -p /home/vscode/.ansible/plugins/
    cp -r plugins/* /home/vscode/.ansible/plugins/
    /home/vscode/.venv/bin/pip install -r requirements.txt
    ```

    Note: the system Python is externally managed (PEP 668), so always install into the venv rather than running `pip install` directly.

3. Then you can test if molecule works correctly:

    ```
    molecule test -s websphere-v90-rockylinux8
    ```
