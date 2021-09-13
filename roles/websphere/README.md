# websphere

The `websphere` role will install IBM WebSphere Application Server (ND).

## Requirements

IBM Installation Manager (1.9.x) must already be installed in the target environment.

## Role Variables

| Property Name            | Default value                                       |
| ------------------------ | --------------------------------------------------- |
| `websphere_install_path` | `/opt/IBM/WebSphere/AppServer`                      |
| `websphere_version`      | `9.0.5.7`                                           |
| ------------------------ | --------------------------------------------------- |
| `iim_install_path`       | `/opt/IBM/InstallationManager`                      |
| `profiled_path`          | `/opt/profile.d`                                    |

## Dependencies

None

## Example Playbook

```
- hosts: servers
  roles:
    - role: spm_middleware.websphere
      websphere_version: 9.0.5.7
```

## License

MIT
