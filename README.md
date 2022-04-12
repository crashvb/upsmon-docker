# upsmon

[![version)](https://img.shields.io/docker/v/crashvb/upsmon/latest)](https://hub.docker.com/repository/docker/crashvb/upsmon)
[![image size](https://img.shields.io/docker/image-size/crashvb/upsmon/latest)](https://hub.docker.com/repository/docker/crashvb/upsmon)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/upsmon-docker.svg)](https://github.com/crashvb/upsmon-docker/blob/master/LICENSE.md)

## Overview

This docker image contains [NUT](https://networkupstools.org/).

## Example Configuration
This is an example dynamic configuration connecting to upsd as a slave.

```yaml
---
version: "3.9"

services:
  upsd:
    ...
    environment:
      UPSMON_UPS_UPSMONSLAVE: |
        MONITOR ups0@myupsdhost 1 upsmonslave $${UPSMONSLAVE_PASSWORD} slave
    ...
```

## Entrypoint Scripts

### upsmon

The embedded entrypoint script is located at `/etc/entrypoint.d/upsmon` and performs the following actions:

1. A new upsmon configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | UPSMON\_NSS\_PATH | `<nut_confpath>/nss` | The path to the NSS database. |
 | UPSMON\_UPS\_* | | The contents to be appended to `<nut_confpath>/upsmon.conf`. |

2. Volume permissions are normalized.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ entrypoint.d/
│  │  └─ upsmon
│  └─ supervisor/
│     └─ config.d/
│        └─ upsmon.conf
└─ run/
   └─ secrets/
      ├─ nss_password
      ├─ upsmon.crt
      ├─ upsmon.key
      ├─ upsmonca.crt
      └─ upsmon_<user>_password
```

### Exposed Ports

None.

### Volumes

* `/etc/nut` - The upsmon configuration directory.

## Development

[Source Control](https://github.com/crashvb/upsmon-docker)

