# db2

The `db2` role will install IBM Db2.

## Requirements

* `passlib` Python module must be installed.

## Role Variables

Ensure you update / override password variables prior to using the role.

| Property Name             | Default value                                       |
| ------------------------- | --------------------------------------------------- |
| `db2_install_path`        | `/opt/IBM/db2`                                      |
| `db2_version`             | `11.5.9.0`                                          |
| `db2_product`             | `DB2_SERVER_EDITION`                                |
| `db2_bypass_prereq_check` | `False`                                             |
| ------------------------- | --------------------------------------------------- |
| `db2_db_create`           | `True`                                              |
| `db2_db_name`             | `DATABASE`                                          |
| `db2_db_username`         | `db2admin`                                          |
| `db2_db_password`         | `db2admin`                                          |
| `db2_db_spm_enc`          | `dummyPassword`                                     |
| `db2_db_drop_required`    | `False`                                             |
| ------------------------- | --------------------------------------------------- |
| `bootstrap_dateformat`    | `dd MM yyyy`                                        |
| `bootstrap_dateseparator` | `/`                                                 |
| `bootstrap_dmx_locale`    | `en_US`                                             |
| ------------------------- | --------------------------------------------------- |
| `download_url`            | # set this if license and installer is being downloaded from a http server|
| `download_header`         | # Use this in conjunction with `download_url`       |
| ------------------------- | --------------------------------------------------- |


## Dependencies

None

## Example Playbook

```
- hosts: servers
  roles:
    - role: merative.spm_middleware.db2
      db2_version: 11.5.9.0
```

## License

MIT
