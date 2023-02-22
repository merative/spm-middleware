# iim

The `iim` role will install the IBM Installation Manager agent. See `iim_package` module for installing packages

## Requirements

None

## Role Variables

| Property Name       | Default value                                         |
| ------------------- | ----------------------------------------------------- |
| `iim_agent_version` | `1.9.1001.20191112_1525`                              |
| `iim_install_path`  | `/opt/IBM/InstallationManager`                        |
| `download_url`      | # Set this if license and installer is being downloaded from a http server|
| `download_header`   | # Use this in conjunction with `download_url` |
| `iim_installer_path`| # Set this to your downloaded installers filepath if copying from local|
|                       # Set to remote filepath if downloading installers    |
| ------------------- | ------------------------------------------------------|

## Dependencies

None

## Example Playbook

```
- hosts: servers
  roles:
    - role:  merative.spm_middleware.iim
```

## License

MIT
