# ihs

The `ihs` role will install IBM HTTP Server.

## Requirements

IBM Installation Manager (1.9.x) must already be installed in the target environment.

## Role Variables

| Property Name           | Default value                                       |
| ----------------------- | --------------------------------------------------- |
| `ihs_install_path`      | `/opt/IBM/HTTPServer`                               |
| `plg_install_path`      | `/opt/IBM/WebSphere/Plugins`                        |
| `wct_install_path`      | `/opt/IBM/WebSphere/Toolbox`                        |
| `ihs_version`           | `9.0.5.8`                                           |
| `ihs_config_type`       | `local_distributed`                                 |
| `ihs_admin_user`        | `wasadmin`                                          |
| `ihs_admin_pass`        | `wasadmin`                                          |
| ----------------------- | --------------------------------------------------- |
| Version-specific:       | Values from `9.0.5.8`                               |
| ----------------------- | --------------------------------------------------- |
| `ihs_installer_archive_list` | `was.repo.90500.[ihs|plugins|wct].zip`              |
| `ihs_fp_installer_path`           | `WAS/9.0.5Fixpacks`                                 |
| `ihs_fp_installer_path`   | `9.0.5-WS-[IHSPLG|WCT]-FP008.zip`                   |
| `ihs_pid`               | `v90_9.0.5008.20210525_1601`                        |
| `ihs_java_zip_path`     | `Java/IBM/ibm-java-sdk-8.0-6.26-linux-x64-installmgr.zip` |
| `ihs_java_pid`          | `com.ibm.java.jdk.v8`                               |
| ----------------------- | --------------------------------------------------- |
| `iim_install_path`      | `/opt/IBM/InstallationManager`                      |
| `profiled_path`         | `/opt/profile.d`                                    |
| ------------------------- | --------------------------------------------------- |
| `download_url`    | # set this if license and installer is being downloaded from a http server |
| `download_header` | # Use this in conjunction with `download_url`               |
| ------------------------- | --------------------------------------------------- |

## Dependencies

IBM Installation Manager (iim)


## Example Playbook

```
---
- hosts: servers
  remote_user: root

  collections:
    - ibm.spm_middleware

  roles:
    - ibm.spm_middleware.iim
    - role: ibm.spm_middleware.ihs
      vars:
        - ihs_version: 8.5.5.17

```

## Example Playbook (Local Development)
```
---
- hosts: servers
  remote_user: root

  collections:
    - ibm.spm_middleware

  roles:
    - ibm.spm_middleware.iim
    - role: ihs
      vars:
        - ihs_version: 8.5.5.17

```

## License

MIT
