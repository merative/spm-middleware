# Contributing

New roles, playbooks, and modules are always welcome.

Contributions must meet a minimum criteria:

* Must have a Molecule scenario/test
* Must be idempotent
* Must pass Ansible linter (run `./scripts/runLint.sh` script)

**Table of Contents:**

* [Prerequisites](#prerequisites)
* [Creating a new role](#creating-a-new-role)
* [Creating a new playbook](#creating-a-new-playbook)
* [Creating a new collection](#creating-a-new-collection)

## Prerequisites

* `git`
* Docker CE
* Python >= 3.6
  * Creating a Python `venv` is highly recommended!
* Python modules listed in `ci-requirements.txt`
  * Can be installed using `pip install -r ci-requirements.txt`
* Repository cloned to `.../ansible_collections/<collection_namespace>/<collection_name>`

## Creating a new role

The role must have a minimum of
* `README.md` file describing its functionality and requirements
* `meta/main.yml` file with the authorship and license information for Ansible Galaxy
* `tasks/main.yml` file with the tasks

This structure can be generated from the provided skeleton structure using

```
ansible-galaxy role init --init-path ./roles --role-skeleton ./skeleton_role awesome_role
```

**Note:** Role names are limited to contain only lowercase alphanumeric characters, plus `_` and must begin with a letter.

### Molecule Tests

To meet the acceptance requirements, the role must have a reasonable Molecule scenario defined.

In the `molecule/` directory, copy the `default` scenario, and update the `converge.yml` and `verify.yml` playbooks to run/check your new role

These playbooks may be run using the `molecule [converge|verify] -s scenario_name` command, similar to Chef's Test-Kitchen framework

### Python venv

Using a python virtual environment is recommended for running molecule tests locally. Create it in the collection root (the root of your repository) with the `venv` command. 

Using a venv lets you keep all the packages and requirements for your molecule tests in an isolated environment that can be cleaned easily from your machine.

```
python3 -m venv myenv (running this in the root of your repo will create a myenv folder)
source myenv/bin/activate (your command line will indicate you are venv. "deactivate" will exit the venv)
brew install yamllint
python3 -m pip install --upgrade setuptools python3 -m pip install "molecule[ansible]"
python3 -m pip install "molecule[docker,lint]"
molecule test -s ihs-v85-centos-7 --destroy never (destroy never tag keeps the docker environment, useful if you have a large download or similar in your test)
```

Docs: https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/

## Creating a new collection

Creating a new collection is quite simple:

* Copy a new repository from the `IBM/ansible_collection_template` repo
* Update the `README.md` and `galaxy.yml` files to match your desired namespace and collection name

To enable the Travis, set the following variables:

* `GITHUB_OAUTH_TOKEN` - GitHub Personal Access Token for tagging/publishing release
* `ARTIFACTORY_TOKEN` - Artifactory API Token, if required for your roles/playbooks
* `ARTIFACTORY_URL` - Artifactory URL, if required for your roles/playbooks
* `ARTIFACTORY_REPO` - Artifactory REPO, if required for your roles/playbooks

**Note:** Make sure to _never_ commit any sensitive or private data!
