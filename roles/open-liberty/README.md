# open-liberty

The `open-liberty` role will install IBM WebSphere Open Liberty.

## Requirements

N/A

## Role Variables

| Property Name           | Default value                                       |
| ----------------------- | --------------------------------------------------- |
| `liberty_install_path`  | `/opt/IBM/WebSphere/Liberty/wlp`                        |
| `liberty_version`       | `23.0.0.12`                                          |
| `liberty_default_heapsize`  | `1024m`                                         |
| `liberty_enable_verbose_gc` | `false`                                         |
| `liberty_extra_jvm_options` | `[]`                                            |
| ----------------------- | --------------------------------------------------- |
| `profiled_path`         | `/opt/profile.d`                                    |

| `download_url`          | # Set this if installation zips are being downloaded from a http server|
| `download_header`       | # Use this in conjunction with `download_url`                          |

| `liberty_installers_path`| # Set these to your downloaded zip filepath if copying from local|
| `liberty_java_zip_path`  |                                                                  |
| ------------------------ | -----------------------------------------------------------------|

## Dependencies

None

## Example Playbook

```
- hosts: servers
  roles:
    - role: merative.spm_middleware.open-liberty
      liberty_version: 23.0.0.12
```

## License

MIT
