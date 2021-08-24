# ant

A role for installing Apache Ant

## Requirements

None

## Role Variables

| Property Name       | Default value                                         |
| ------------------- | ----------------------------------------------------- |
| `ant_version`       | `1.10.6`                                              |
| `ant_base_path`     | `[/opt | C:\Tools]`                                   |
| ------------------- | ----------------------------------------------------- |
| `artifactory_token` | Environment variable: `EUSWG_TOKEN`                   |
| `artifactory_url`   | `https://eu.artifactory.swg-devops.com/artifactory`   |
| `artifactory_repo`  | `wh-spmdevops-generic-local`                          |
| ------------------- | ----------------------------------------------------- |
| `profiled_path`     | `/opt/profile.d`                                      |

## Dependencies

None

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: wh_spm.toolbox.ant, x: 42 }

## License

MIT
