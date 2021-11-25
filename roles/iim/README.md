# iim

The `iim` role will install the IBM Installation Manager agent. See `iim_package` module for installing packages

## Requirements

None

## Role Variables

| Property Name       | Default value                                         |
| ------------------- | ----------------------------------------------------- |
| `iim_agent_version` | `1.9.1001.20191112_1525`                              |
| `iim_install_path`  | `/opt/IBM/InstallationManager`                        |
| `iim_installer_path`| # Set this to your downloaded installers filepath if copying from local|
|                       # Set to remote filepath if downloading installers    |
|                       # Default `/tmp/iim/`                                 |
| ------------------- | ------------------------------------------------------|
| `download_url`      | # Set this if license and installer is being downloaded from a http server|
| `download_header`   | # Use this in conjunction with `download_url` |
| ------------------- | ------------------------------------------------------|


## Dependencies

None

## Example Playbook

```
---
- name: Deploy IIM
  hosts: servers
  collections:
    - ibm.spm_middleware

  vars:
    download_url: "https://myserver.com/db2/repos"
    download_header: { 'Authorization': 'Basic EncodedString'}

  roles:
    - role:  ibm.spm_middleware.iim

```

## License

MIT
