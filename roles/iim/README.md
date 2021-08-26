# iim

The `iim` role will install the IBM Installation Manager agent. See `iim_package` module for installing packages

## Requirements

None

## Role Variables

| Property Name       | Default value                                         |
| ------------------- | ----------------------------------------------------- |
| `iim_agent_version` | `1.9.1001.20191112_1525`                              |
| `iim_install_path`  | `/opt/IBM/InstallationManager`                        |

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
