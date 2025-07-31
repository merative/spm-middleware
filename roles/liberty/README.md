# liberty

The `liberty` role will install IBM WebSphere Liberty.

## Requirements

IBM Installation Manager (1.9.x) must already be installed in the target environment.

## Role Variables

| Property Name           | Default value                                       |
| ----------------------- | --------------------------------------------------- |
| `liberty_install_path`  | `/opt/IBM/WebSphere/Liberty`                        |
| `liberty_version`       | `25.0.0.7`                                         |
| `liberty_default_heapsize`  | `1024m`                                         |
| `liberty_enable_verbose_gc` | `false`                                         |
| `liberty_extra_jvm_options` | `[]`                                            |
| ----------------------- | --------------------------------------------------- |
| `iim_install_path`      | `/opt/IBM/InstallationManager`                      |
| `profiled_path`         | `/opt/profile.d`                                    |
| ----------------------- | --------------------------------------------------- |
| `download_url`          | # Set this if installation zips are being downloaded from a http server|
| `download_header`       | # Use this in conjunction with `download_url`                          |
| ----------------------- | --------------------------------------------------- |
| `liberty_installers_path`| # Set these to your downloaded zip filepath if copying from local|
| `liberty_fp_path`        | # Set to remote filepath if downloading                          |
| `liberty_java_zip_path`  |                                                                  |
| ------------------------ | -----------------------------------------------------------------|

## Dependencies

None

## Example Playbook

```
- hosts: servers
  roles:
    - role: merative.spm_middleware.liberty
      liberty_version: 25.0.0.7
```

## License

MIT
