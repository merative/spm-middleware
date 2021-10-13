# Weblogic

The `weblogc` role will install Weblogic.

## Requirements

* CentOS-7/8, Redhat 7.x/8.x

## Role Variables

| Property Name             | Default value                                       |
| ------------------------- | --------------------------------------------------- |
| `weblogic_base`           | `/home/oracle`                                      |
| `weblogic_home`           | `/home/oracle/Oracle/Middleware/Oracle_Home`        |
| `server_port`             | `7001`                                              |
| `download_url`            | # Set this if license and installer is being downloaded from a http server|
| `download_header`         | # Use this in conjunction with `download_url` |
| `weblogic_installer_path` | Controller local path or relative to download_url |
| `weblogic_patch_path`     | Controller local path or relative to download_url |
| `java_zip_path`           | Controller local path or relative to download_url |

| ------------------------- | --------------------------------------------------- |
| ** `weblogic_version` **  | `12.1.3.0.2`                                        |
|                           | `12.1.3.0.210720`                                   |
|                           | `12.2.1.4.210716`                                   |
|                           | `14.1.1.0.210716`                                   |

...

## Dependencies

Download WebLogic Server Installation packages and patch packages, and upload it to: wh-spmdevops-generic-local/SoftwareInstallers/WLS/ .

## Example Playbook

The following explains the structure of this role.
tasks/main.yml
 - defaults/main.yml vars file is included (default weblogic_version is '14.1.1.0.210716' if no alternative is passed in with your ansible-playbook command)
 - runs: prereqs.yml
 - runs: install.yml
 - runs: patch.yml

If the version specific var file includes a "opatch_file" variable is set an Opatch
will be installed by including the run_opatch.yml task file.

The version of the OPatch tool itself is also handed by the above tasks file.

```
- hosts: servers
  roles:
    - role: wh_spm.middleware.weblogic
      weblogic_version: 14.1.1.0.210716
```

## Note

1. Default JDK version is 1.8.0_191. Required by Dev Team.
2. We keep 12.1.3.0.2. This is not the latest version. Required by Dev Team.

## License

MIT
