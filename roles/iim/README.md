# iim

The `iim` role will install the IBM Installation Manager agent. See `iim_package` module for installing packages

## Requirements

None

## Role Variables

| Property Name       | Default value                                         |
| ------------------- | ----------------------------------------------------- |
| `iim_agent_version` | `1.9.1001.20191112_1525`                              |
| `iim_install_path`  | `/opt/IBM/InstallationManager`                        |
| `download_url`            | # set this if license and installer is being downloaded from a http server|
| `download_header`         | # Use this in conjunction with `download_url`   |
| ------------------------- | ------------------------------------------------|

## Dependencies

None

## Example Playbook

```
- hosts: servers
  roles:
    - role:  ibm.spm_middleware.iim
```

## License

MIT
