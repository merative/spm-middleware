# SPM Middleware Collection Guidelines

This is an Ansible collection (`merative.spm_middleware`) for installing middleware required by Cúram Social Program Management. Suitable for internal test and development only.

## Code Style

### YAML Formatting
- Follow `.yamllint` configuration (extends default with relaxed line-length and truthy rules)
- Use `---` at the start of all YAML files
- Indent with 2 spaces, no tabs
- Allow max 1 space inside braces and brackets: `{ key: value }` not `{key:value}`
- Use lowercase boolean values: `yes/no` or `true/false`

### Ansible Conventions
- Use fully qualified collection names (FQCN) in playbooks: `merative.spm_middleware` collection
- Always include `collections:` block in converge.yml playbooks
- Use `name:` for all tasks for better readability
- Use `include_tasks` for conditional task inclusion
- Check state before installation: use `register` + `when` to avoid re-running installations

### Variable Naming
- Role-specific variables start with role name: `db2_version`, `weblogic_install_path`
- Use snake_case for all variables
- Document all variables with defaults in role's README.md
- Keep sensitive defaults like passwords in defaults/main.yml but document they must be overridden

## Architecture

### Collection Structure
- **roles/**: Middleware installation roles (db2, ihs, iim, liberty, ohs, oracle, weblogic, websphere)
- **molecule/**: Test scenarios for each middleware version and OS combination
- **plugins/**: Custom Ansible modules and module utilities
- **playbooks/**: Example playbooks
- **tests/**: Integration and sanity tests

### Role Structure (Standard Ansible Layout)
```
role_name/
├── README.md         # Required: document all variables and requirements
├── defaults/         # Default variables
├── tasks/            # Task files (main.yml is entry point)
├── templates/        # Jinja2 templates
├── files/            # Static files
├── vars/             # Version-specific variables (e.g., v11.5.9.0.yml)
└── meta/             # Role metadata
```

### Molecule Scenarios
- **Naming pattern**: `{middleware}-{version}-{os}` (e.g., `weblogic-12214-rockylinux9`)
- **Legacy scenarios**: Prefixed with `__` (double underscore) for deprecated/old versions
- **Resources**: Shared `_resources/Dockerfile.j2` for building test containers
- Each scenario contains: `molecule.yml` (config), `converge.yml` (install), `verify.yml` (test)

## Build and Test

### Dev Container Setup
This project uses VS Code Dev Containers with Docker-in-Docker:

1. Create `.devcontainer/.env` with:
   ```bash
   ARTIFACTORY_URL=https://artifactory.example.com/artifactory
   ARTIFACTORY_REPO=software-repo-name
   ARTIFACTORY_TOKEN=your-token
   LOCAL_PATH=/workspaces/spm-middleware
   ```

2. Container auto-runs: `pip install -r requirements.txt` and copies plugins to `~/.ansible/plugins/`

### Running Tests
```bash
# Test single scenario
molecule test -s weblogic-12214-rockylinux9

# Test and keep container for debugging
molecule test -s weblogic-12214-rockylinux9 --destroy never

# Run sanity tests
ansible-test sanity --docker -v --color --python 3.6
```

### Molecule Test Sequence
Default: `dependency → cleanup → destroy → syntax → create → prepare → converge → idempotence → side_effect → verify → cleanup → destroy`

### Environment Variables
- `ARTIFACTORY_URL`: Base URL for artifact repository
- `ARTIFACTORY_REPO`: Repository name containing installers
- `ARTIFACTORY_TOKEN`: Authentication token (use in `download_header`)

## Conventions

### Adding New Middleware/Versions

1. **Create version-specific vars**: Add `vars/v{version}.yml` in role with installer URLs and checksums
2. **Create molecule scenario**: Use naming pattern `{middleware}-{version}-{os}`
3. **Update galaxy.yml**: Increment version following semver
4. **Test thoroughly**: Run full molecule test cycle before committing

### Converge Playbook Pattern
```yaml
---
- name: Converge
  hosts: all

  collections:
    - merative.spm_middleware

  roles:
    - role_name

  vars:
    role_version: "x.y.z"
    download_url: "{{ lookup('env', 'ARTIFACTORY_URL') }}/{{ lookup('env', 'ARTIFACTORY_REPO') }}/SoftwareInstallers"
    download_header: { 'X-JFrog-Art-Api': "{{ lookup('env', 'ARTIFACTORY_TOKEN') }}"}
```

### Idempotency
- Always check if software is already installed before attempting installation
- Use `changed_when: false` for check commands (e.g., `db2level`, version checks)
- Use `ignore_errors: yes` + `register` for conditional installation logic
- Tasks should be re-runnable without causing errors or unnecessary changes

### File Organization
- Version-specific logic goes in `vars/v{version}.yml`, not in tasks
- Installation logic in `tasks/install.yml`
- Prerequisites in `tasks/prereqs.yml`
- Configuration in `tasks/configure.yml` or similar
- Main `tasks/main.yml` orchestrates includes based on state checks

### Documentation
- Every role must have a README.md with:
  - Role purpose and requirements
  - Variable table with defaults
  - Example usage
- See `roles/db2/README.md` for reference format
- Link to external docs rather than embedding: "See CONTRIBUTING.md for setup details"

### Version Management
- Collection version in `galaxy.yml` must follow semantic versioning
- Update version in both `galaxy.yml` and `.github/workflows/release.yml`
- Each middleware role supports multiple versions via vars files

### Testing New Scenarios
- Start from existing similar scenario as template
- Use appropriate base image: `rockylinux:8` or `rockylinux:9`
- Include privileged mode and cgroup mounts for systemd-based services
- Verify installers are accessible before running full test

### PR Requirements
Before committing code:
- **All molecule tests must pass**: Run `molecule test -s <scenario>` for affected scenarios
- Test both installation and idempotency: Do not use `--destroy never` for final validation
- Verify on appropriate OS targets (rockylinux8/rockylinux9)
- Update documentation if adding new variables or changing behavior

### Contribution Workflow
See `CONTRIBUTING.md` for detailed setup and `README.md` for dev container usage.
