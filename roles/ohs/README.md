# oracle

The `ohs` role will install and patch Oracle HTTP Server, the Web server component for Oracle Fusion Middleware

## Requirements

* `python3` to be installed on the host
* `ansible_python_interpreter` set to `python3`
* `passlib` Python module must be installed.

## Role Variables
NOTE: Update these default usernames and passwords after the initial installation.
| Property Name             | Default value                                       |
| ------------------------- | --------------------------------------------------- |
| `ohs_version`             | `12.2.1.4.210324`                                   |
| `ohs_user`                | `oracle`                                            |
| `ohs_admin_password`      | `password1`                                         |
| `ohs_group`               | `oinstall`                                          |
| `ohs_base`                | `/home/oracle`                                      |
| `ohs_home`                | `/home/oracle/Oracle/Middleware/HTTP_Oracle_Home`   |
| `ohs_port`                | `7002`                                              |
| `keystore_password`       | `Passw0rd`
| ------------------------- | --------------------------------------------------- |
| `weblogic_user`           | `weblogic`                                          |
| `weblogic_password`       | `Password1`                                         |
| ------------------------- | --------------------------------------------------- |
| `profiled_path`           | `/opt/profile.d`                                    |
| ------------------------- | --------------------------------------------------- |
| `download_url`            | # set this if license and installer is being downloaded from a http server|
| `download_header`         | # Use this in conjunction with `download_url`       |
| ------------------------- | --------------------------------------------------- |

## Dependencies

Although the role can be used independently, it is expected that Weblogic is already installed on the host and will not function correctly without it.

## Example Playbook

```
---
- name: Deploy OHS
  hosts: servers
  collections:
    - ibm.spm_middleware

  vars:
    ohs_version: 12.2.1.4.210324
    download_url: "https://myserver.com/ohs/repos"
    download_header: { 'Authorization': 'Basic EncodedString'}

  roles:
    - role: ibm.spm_middleware.ohs

```
## License

MIT
