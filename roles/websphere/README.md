# websphere

The `websphere` role will install IBM WebSphere Application Server (ND).

## Requirements

IBM Installation Manager (1.9.x) must already be installed in the target environment.

## Role Variables

| Property Name            | Default value                                       |
| ------------------------ | --------------------------------------------------- |
| `websphere_install_path` | `/opt/IBM/WebSphere/AppServer`                      |
| `websphere_version`      | `9.0.5.8`                                           |
| ------------------------ | --------------------------------------------------- |
| `iim_install_path`       | `/opt/IBM/InstallationManager`                      |
| `profiled_path`          | `/opt/profile.d`                                    |
| ------------------------- | --------------------------------------------------- |
| `download_url`            | # set this if license and installer is being downloaded from a http server|
| `download_header`         | # Use this in conjunction with `download_url`       |
| ------------------------- | --------------------------------------------------- |

## Dependencies

ibm.spm_middleware.iim

## Example Playbook

```
---
- name: Converge
  hosts: all

  collections:
    - ibm.spm_middleware

  vars:
    websphere_version: 9.0.5.8
    download_url: "https://myserver.com/was/repos"
    download_header: { 'Authorization': 'Basic EncodedString'}

  roles:
    - ibm.spm_middleware.iim
    - ibm.spm_middleware.websphere
```

## License

MIT
