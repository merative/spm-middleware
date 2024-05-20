# oracle

The `oracle` role will install Oracle Database EE Single Instance.

## Requirements

* `passlib` Python module must be installed.

## Role Variables

| Property Name             | Default value                                       |
| ------------------------- | --------------------------------------------------- |
| `oracle_version`          | `19.23.0.0.0`                                       |
| `oracle_base`             | `/opt/oracle`                                       |
| `oracle_home`             | `/opt/oracle/product/<oracle_family>/dbhome_1`                  |
| `oracle_inventory`        | `/opt/Oracle/oraInventory`                          |
| ------------------------- | --------------------------------------------------- |
| `oracle_global_name`      | `orcl.<domain>`                                     |
| `oracle_sid`              | `orcl`                                              |
| `oracle_admin_password`   | `Password1`                                         |
| `sql_username`            | `curam`                                             |
| `sql_password`            | `p`                                                 |
| `enc_sql_password`        | `gc8TRn5L0ZQJDzI2yZvtQw==`                          |
| ------------------------- | --------------------------------------------------- |
| `bootstrap_dateformat`    | `dd MM yyyy`                                        |
| `bootstrap_dateseparator` | `/`                                                 |
| `bootstrap_dmx_locale`    | `en_US`                                             |
| ------------------------- | --------------------------------------------------- |
| `oracle_installer_path`   | # Either local controller path or relative to `download_url`  |
| `download_url`            | # set this if license and installer is being downloaded from a http server|
| `download_header`         | # Use this in conjunction with `download_url`       |
| ------------------------- | --------------------------------------------------- |
| `profiled_path`           | `/opt/profile.d`                                    |

## Dependencies

None

## Example Playbook

```
- hosts: servers
  roles:
    - role: merative.spm_middleware.oracle
      oracle_version: 19.23.0.0.0

## License

MIT
```
