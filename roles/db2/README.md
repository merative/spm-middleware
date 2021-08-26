# db2

The `db2` role will install IBM Db2.

## Requirements

* `passlib` Python module must be installed.

## Role Variables

| Property Name             | Default value                                       |
| ------------------------- | --------------------------------------------------- |
| `db2_install_path`        | `/opt/IBM/db2`                                      |
| `db2_version`             | `11.1.4.6`                                          |
| `db2_product`             | `DB2_SERVER_EDITION`                                |
| `db2_bypass_prereq_check` | `False`                                             |
| ------------------------- | --------------------------------------------------- |
| `db2_db_create`           | `True`                                              |
| `db2_db_name`             | `DATABASE`                                          |
| `db2_db_username`         | Environment variable: `DB2_USER`                    |
| `db2_db_password`         | Environment variable: `DB2_PASSWORD`                |
| `db2_db_spm_enc`          | Environment variable: `DB2_ENC_PASSWORD`            |
| `db2_db_drop_required`    | `False`                                             |
| ------------------------- | --------------------------------------------------- |
| `bootstrap_dateformat`    | `dd MM yyyy`                                        |
| `bootstrap_dateseparator` | `/`                                                 |
| `bootstrap_dmx_locale`    | `en_US`                                             |
| ------------------------- | --------------------------------------------------- |

## Dependencies

None

## Example Playbook

```
- hosts: servers
  roles:
    - role: ibm.spm_middleware.db2
      db2_version: 11.1.4.6
```

## License

MIT
