---
name: add-middleware-fixpack
description: >
  Add a new version of a middleware role to the spm-middleware collection.
  Use this skill when a new quarterly patch/fixpack release needs to be added
  for any of the supported middleware roles: db2, ihs, iim, liberty, ohs,
  oracle, weblogic, or websphere.
---
# Add Middleware Version

## Overview

Adds a new version of a middleware role. This involves creating a version-specific
vars file, updating the molecule test scenario(s) to reference the new version,
updating the role's README.md version table and version-specific parameter rows,
and updating `defaults/main.yml` if the new version becomes the new default.

## Inputs

- The target **role name** (db2, ihs, liberty, ohs, oracle, weblogic, websphere)
- The new **version string** (e.g. `9.0.5.28`, `26.0.0.6`, `14.1.2.0.260701`)
- Installer filenames, patch numbers, and artifact paths — ask the user if not provided
- Whether this version becomes the new **default** (if unsure, assume yes)
- For **liberty**: the new `liberty_pid` string — this changes with every fixpack and must
  be provided for both the JDK8 and JDK21 variants (they share the same value)
- For **websphere**: the new `iim_agent_version` string, if IBM Installation Manager has been updated alongside this fixpack (ask the user; if unchanged, keep the existing value)
- For **ohs**: the new `weblogic_version` to deploy alongside OHS — ask the user for each OHS family being updated, as each scenario's `converge.yml` pins a specific WebLogic version

## Steps

### 1. Create the vars file

Create `roles/{role}/vars/v{version}.yml` by copying the most recent existing
vars file for the same role family (same major/minor line) and updating all
version-specific values. Use the correct schema per role (see Guidelines).
Do **not** base a 26ai Oracle file on a 19c file, etc.

### 2. Update molecule scenario(s)

Find every molecule scenario under `molecule/` that tests the role family being
updated and update the version string in its `converge.yml`.

- For roles using a **shared legacy converge** (`__`-prefixed directory), update
  the `{role}_version` var in that shared `converge.yml`.
- For **websphere**, also update `iim_agent_version` in `molecule/__websphere-v{major}/converge.yml`
  if a new IIM version was provided by the user.
- For db2, each scenario has its **own** `converge.yml` — update it directly.
  Also update the version assertion in each scenario's `verify.yml` (e.g. the
  string `'v12.1.4' in db2level_cmd.stdout` must match the new major.minor.patch,
  such as `'v12.1.5'`).
- For **ohs**, also update the `weblogic_version` var in each scenario's `converge.yml` (the OHS converge deploys WebLogic alongside OHS). Also update the vars file reference in each scenario's `verify.yml` (line referencing `../../roles/ohs/vars/v{old_version}.yml`) to point to the new vars file. The correct scenario directories are `molecule/__ohs-v{family}/` where family matches the version being updated (e.g. `__ohs-v12.2.1.4` for the 12.2.1.4 family, `__ohs-v14.1.2` for the 14.1.2 family).
- For **oracle**, also update the `oracle_version` var in each scenario's `verify.yml` (`molecule/__oracle-v{family}/verify.yml`). The var appears near the top of the `vars:` block.
- For **weblogic**, also update the vars file reference in each scenario's `verify.yml` (`molecule/__weblogic-v{family}/verify.yml`), on the line referencing `../../roles/weblogic/vars/v{old_version}.yml`.
- The `molecule.yml` does **not** need changing unless adding a new OS target.

Make the following updates in `roles/{role}/README.md`:

#### Version table
- If a row for the same major/minor family already exists, **replace** the version
  string in that row with the new version. Do not accumulate multiple patch versions
  on the same family line.
- If this is a version from a **new family** not yet represented in the table
  (e.g. adding `8.5.5` when only `9.0.5` rows exist), **add** a new row for it.
- Only remove old versions when explicitly asked.

#### Version-specific section
The README contains a `Version-specific` section that shows representative values
from the current default version. When adding a new version that is the new default,
update all the values in this section to match the new vars file:
- The `Values from \`{version}\`` label
- Each parameter value row (archive names, FP path, PID, Java zip path, etc.)

#### Example playbook
Update any version string referenced in the Example Playbook section to match
the new default version.

### 4. Update defaults/main.yml (if new default)

If the new version is the new default, update the `{role}_version` variable in
`roles/{role}/defaults/main.yml`.

> **db2 exception**: Do **not** update `roles/db2/defaults/main.yml`. The db2
> default version is intentionally pinned to the base GA release (e.g. `12.1.0.0`)
> and must not be changed when adding a fixpack.

### 5. Remind the user to bump galaxy.yml

Do **not** edit `galaxy.yml` automatically. Instead, remind the user at the end:

> Remember to increment the **patch** version in `galaxy.yml` before raising your PR
> (e.g. `1.10.9` → `1.10.10`). One bump per PR regardless of how many roles were updated.
> `galaxy.yml` is the single source of truth — no change is needed in `release.yml`.

## Guidelines

### Vars file schemas by role

**db2**
```yaml
---
db2_installer_path: DB2/{major_minor}/v{version}_linuxx64_universal_fixpack.tar.gz
db2_license_path: DB2/{major_minor}/db2ese_u.lic
```

**ihs (9.0.5 family)**
```yaml
---
ihs_installer_path: WAS/{major_minor}ND
ihs_installer_archive_list:
  - was.repo.{5digit_ver}.ihs.zip
  - was.repo.{5digit_ver}.plugins.zip
  - was.repo.{5digit_ver}.wct.zip

ihs_fp_installer_path: WAS/{major_minor}Fixpacks
ihs_fp_installer_archive_list:
  - {major_minor}-WS-IHSPLG-FP{fp_padded}.zip
  - {major_minor}-WS-WCT-FP{fp_padded}.zip

ihs_pid: v{major_2digit}_{full_pid_string}

ihs_java_zip_path: Java/IBM/ibm-java-sdk-8.0-{build}-linux-x64-installmgr.zip
ihs_java_pid: com.ibm.java.jdk.v8
```

**ihs (8.5.5 family)** — no Java fields; uses multi-part supplement archives
```yaml
---
ihs_installer_path: WAS/8.5.5ND
ihs_installer_archive_list:
  - WAS_V8.5.5_SUPPL_1_OF_3.zip
  - WAS_V8.5.5_SUPPL_2_OF_3.zip
  - WAS_V8.5.5_SUPPL_3_OF_3.zip

ihs_fp_installer_path: WAS/8.5.5Fixpacks/FP{fp_number}
ihs_fp_installer_archive_list:
  - 8.5.5-WS-WASSupplements-FP{fp_padded}-part1.zip
  - 8.5.5-WS-WASSupplements-FP{fp_padded}-part2.zip
  - 8.5.5-WS-WASSupplements-FP{fp_padded}-part3.zip

ihs_wct_installer_list:
  - 8.5.5-WS-WCT-FP{fp_padded}-part1.zip
  - 8.5.5-WS-WCT-FP{fp_padded}-part2.zip

ihs_pid: v85_{full_pid_string}
ihs_base_pid: v85_8.5.5000.20130514_1044
```
> Do **not** ask for a Java build number when adding an 8.5.5 version.

**liberty** — two files per release: `v{version}.yml` (JDK8) and `v{version}-JDK21.yml`
```yaml
# JDK8 variant
---
liberty_fp_path: WLP/{version}-WS-LIBERTY-ND-FP.zip
liberty_installers_path: WLP/was.repo.{5digit}.liberty.nd.zip
liberty_pid: {pid_string}          # changes every fixpack — ask the user
liberty_java_zip_path: Java/IBM/ibm-java-sdk-8.0-{build}-linux-x64-installmgr.zip
liberty_java_pid: com.ibm.java.jdk.v8_{build_string}

# JDK21 variant
---
liberty_fp_path: WLP/{version}-WS-LIBERTY-ND-FP.zip
liberty_installers_path: WLP/was.repo.{5digit}.liberty.nd.zip
liberty_pid: {pid_string}          # same value as JDK8 variant — changes every fixpack
jdk_version: 21.0
jdk_installation_way: unzip
liberty_java_zip_path: Java/IBM/ibm-semeru-open-jdk_x64_linux_{jdk_version}.tar.gz
```

**ohs**
```yaml
---
# Base Information
ohs_version_folder: {major_minor}
base_version: "{major_minor}.0.0"
base_installer: fmw_{major_minor}.0.0_ohs_linux64.bin
base_installer_path: "OHS/{major_minor}/fmw_{major_minor}.0.0_ohs_linux64.bin"

# Patch information
ohs_version: {full_version}
patches:
  - filename: "OHS/{major_minor}/p{patch_number}_{base_short}_Linux-x86-64.zip"
    number: {patch_number}

# OPatch Information  <- update opatch_version each release.
#                        The leading patch number p28186730 is constant and never changes.
#                        Derive the middle segment by removing dots from opatch_version
#                        e.g. opatch_version 13.9.4.2.24 → middle segment 1394224
opatch_filename_path: "WLS/Patches/p28186730_{opatch_version_digits}_Generic.zip"
opatch_version: {opatch_version}
opatch_folder: 6880880

# JDK Information
java_zip_path: 'WLS/jdk-{jdk_version}_linux-x64_bin.tar.gz'
java_version_path: 'jdk-{jdk_version}'
jdk_folder: "{{ ohs_home }}/oracle_common/jdk"

template_jar: "ohs_standalone_template.jar"
```

**oracle** — base on the matching family (19c or 26ai)
```yaml
# 19c
---
# prereq installers
prereqs_installer_8: https://yum.oracle.com/...el8...rpm
prereqs_installer: "{{ prereqs_installer_8 if ansible_distribution_major_version=='8' else prereqs_installer_9 }}"
# base installer values
base_version: 19.3.0.0.0
base_installer: oracle-database-ee-19c-1.0-1.x86_64.rpm
# patch values
patch_filename: p{patch_number}_190000_Linux-x86-64.zip
patch_number: {patch_number}
# opatch values
opatch_filename: p6880880_190000_Linux-x86-64.zip
opatch_version: {opatch_version}
# jdkpatch values
jdk_patch_filename: p{jdk_patch_number}_190000_Linux-x86-64.zip
jdk_patch_number: {jdk_patch_number}

# 26ai — also include these
oracle_family: "26ai"
sql_username: c##curam
```

**weblogic**
```yaml
---
# base install file
base_install_file: 'fmw_{major_minor}.0.0_wls.jar'
weblogic_version: {major_minor}      # e.g. 14.1 or 14.1.2
# opatch  <- update both of these each release
opatch: 'p{opatch_patch_number}_1394223_Generic.zip'
opatch_version: {opatch_version}
# wls patch version
patch: 'p{patch_number}_{base_short}_Generic.zip'
patch_number: {patch_number}
napply: False
patch_folder: '{patch_number}'
# jdk version (java8: jdk-8u{n}-linux-x64.tar.gz / java21: jdk-{ver}_linux-x64_bin.tar.gz)
java_archive_file: jdk-{jdk_version}_linux-x64_bin.tar.gz
java_version_path: '{jdk_version_dir}'
```

**websphere**
```yaml
---
# FP Vars
websphere_pid: v{major_2digit}_{full_pid_string}
websphere_fp_path: WAS/{major_minor}Fixpacks
websphere_fp_archive_list:
  - {major_minor}-WS-WAS-FP{fp_padded}.zip

# Base Vars
websphere_base_pid: com.ibm.websphere.ND.v{major_2digit}
websphere_base_path: WAS/{major_minor}ND
websphere_base_archive_list:
  - was.repo.{5digit_ver}.nd.zip

# Java Vars
websphere_java_path: Java/IBM/ibm-java-sdk-8.0-{build}-linux-x64-installmgr.zip
websphere_java_pid: com.ibm.java.jdk.v8
websphere_java_home: java/8.0
```

### Molecule version variable names per role

| Role      | Variable            | Shared converge location                                         |
|-----------|---------------------|------------------------------------------------------------------|
| db2       | `db2_version`       | Each scenario's own `converge.yml`                               |
| ihs       | `ihs_version`       | `molecule/__ihs-v{major}/converge.yml`                           |
| liberty   | `liberty_version`   | `molecule/__liberty/converge.yml` and `__liberty21/converge.yml` |
| ohs       | `ohs_version`       | `molecule/__ohs-v{family}/converge.yml`                          |
| oracle    | `oracle_version`    | `molecule/__oracle-v{family}/converge.yml`                       |
| weblogic  | `weblogic_version`  | `molecule/__weblogic-v{major}/converge.yml`                      |
| websphere | `websphere_version` | `molecule/__websphere-v{major}/converge.yml`                     |

### README version table format

```markdown
| ----------------------------------- | --------------------------------------------------- |
| ** `{role}_version` **              | `{version_a}`                                       |
|                                     | `{version_b}`                                       |
| ----------------------------------- | --------------------------------------------------- |
```

### YAML formatting

- `---` at top of every new YAML file
- 2-space indentation, no tabs
- Lowercase booleans (`true`/`false`)
- Comment above each logical variable group, matching the style of existing vars files
