# ihs

The `ihs` role will install IBM HTTP Server.

## Requirements

IBM Installation Manager (1.9.x) or higher must already be installed in the target environment.

## Role Variables
NOTE: ihs_admin_pass should be changed after first installation.
| Property Name           | Default value                                       |
| ----------------------- | --------------------------------------------------- |
| `ihs_install_path`      | `/opt/IBM/HTTPServer`                               |
| `plg_install_path`      | `/opt/IBM/WebSphere/Plugins`                        |
| `wct_install_path`      | `/opt/IBM/WebSphere/Toolbox`                        |
| `ihs_version`           | `9.0.5.24`                                           |
| `ihs_config_type`       | `local_distributed`                                 |
| `ihs_admin_user`        | `wasadmin`                                          |
| `ihs_admin_pass`        | `wasadmin`                                          |
| ----------------------- | --------------------------------------------------- |
| Version-specific:       | Values from `9.0.5.24`                               |
| ----------------------- | --------------------------------------------------- |x  
| `ihs_installer_archive_list` | `was.repo.90500.[ihs|plugins|wct].zip`         |
| `ihs_fp_installer_path` | `WAS/9.0.5Fixpacks`                                 |
| `ihs_fp_installer_archive_list` | `9.0.5-WS-[IHSPLG|WCT]-FP024.zip`           |
| `ihs_pid`               | `v90~9.0.5024.20250528_1830`                        |
| `ihs_java_zip_path`     | `Java/IBM/ibm-java-sdk-8.0-8.45-linux-x64-installmgr.zip` |
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
merative.spm_middleware.iim

## Example Playbook

```
---
- name: Deploy IHS
  hosts: all

  collections:
    - merative.spm_middleware

  roles:
    - merative.spm_middleware.iim
    - merative.spm_middleware.ihs
      vars:
        - ihs_version: 9.0.5.24
        - download_url: "https://myserver.com/IHS/repos"
        - download_header: { 'Authorization': 'Basic EncodedString'}
```

## License

MIT
