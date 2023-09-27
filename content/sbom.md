---
title: Bom Resolver
author: Hans Thorsen Lamm
---
# SBOM 

The project comes with a reference suite, providing a simple static webserver. 

## Desired SBOM 

Just add two lines 

```
alpine-base
lighttpd #S
```



The two packages have several dependencies that originates how Alpine compile the source code 

```
./configure --with-ldap --with-openssl --with-zstd --with-brotli --with-lua

```

To get all transitive dependencies according to [CISA](https://www.cisa.gov/sites/default/files/publications/Dec15-SBOM-a-rama-slides.pdf).  iteration start until the resolver reports true. 

Each iteration reports packages to be added to the desired SBOM. In this example four passes are required. 


```
# 
# This is the reference image 
#
alpine-base

lighttpd #S

# Pass 1 

openssl
brotli
openldap
lua5.4
zstd

# Pass 2

ncurses
libtool
cyrus-sasl
util-linux

# Pass 3

heimdal

# Pass 4

e2fsprogs
```



The APKBUILD for lighttpd could be modified to exclude dependencies  For deployment in Kubernetes TLS is handled in api gateways/sidecar. 

For deployment as standalone ldap and openssl may be needed. ECO systems with pre-compiled packages suites many use cases, but is not optimized for one specific. 

Bom Resolver enables to start prototyping with existing packages and then customize to meet the requirements. 



```
./configure 

```





## Software composition 

Aggregations split large projects into smaller packages 

- commands 
- services 
- libraries 
- headers for development 
- documentation 

Format reports which library orginates from which package. This is useful for triage handling of vulnerabilities and also hardening. 

 

```json
            "depends": {
                            "develop": {
                                "libbrotlienc.so.1": {
                                    "parent": "brotli",
                                    "child": "brotli-libs"
                                },
                                "libc.musl-x86_64.so.1": {
                                    "parent": "musl"
                                },
                                "libcrypto.so.1.1": {
                                    "parent": "openssl",
                                    "child": "libcrypto1.1"
                                },
                                "libdbi.so.1": {
                                    "parent": "libdbi"
                                },
                                "liblber.so.2": {
                                    "parent": "openldap",
                                    "child": "libldap"
                                },
                                "libldap.so.2": {
                                    "parent": "openldap",
                                    "child": "libldap"
                                },
                                "liblua-5.4.so.0": {
                                    "parent": "lua5.4",
                                    "child": "lua5.4-libs"
                                },
                                "libpcre2-8.so.0": {
                                    "parent": "pcre2"
                                },
                                "libssl.so.1.1": {
                                    "parent": "openssl",
                                    "child": "libssl1.1"
                                },
                                "libz.so.1": {
                                    "parent": "zlib"
                                },
                                "libzstd.so.1": {
                                    "parent": "zstd",
                                    "child": "zstd-libs"
                                }
                            },

```
## Source code 

The metadata is used for rebuild in isolation, therefore two locations are required. 

- Location on Internet
- Where to store software for rebuild

The aggregation model supports vendor specific patches and local files not contributed to the upstream project. 

 

```json
"source": {
                    "external": {
                        "patch": [],
                        "code": [
                            {
                                "remote": {
                                    "type": "generic",
                                    "url": "https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.64.tar.xz"
                                },
                                "local": {
                                    "type": "file",
                                    "path": "main/lighttpd/lighttpd-1.4.64.tar.xz"
                                }
                            }
                        ]
                    },
                    "internal": {
                        "code": [
                            {
                                "remote": {
                                    "type": "git",
                                    "commit": {
                                        "hash": "1016b47723",
                                        "tag": "v3.16.3"
                                    },
                                    "url": "git://git.alpinelinux.org/aports",
                                    "path": "main/lighttpd/lighttpd.pre-install"
                                },
                                "local": {
                                    "type": "file",
                                    "path": "main/lighttpd/lighttpd.pre-install"
                                }
                            },
                            {
                                "remote": {
                                    "type": "git",
                                    "commit": {
                                        "hash": "1016b47723",
                                        "tag": "v3.16.3"
                                    },
                                    "url": "git://git.alpinelinux.org/aports",
                                    "path": "main/lighttpd/lighttpd.pre-upgrade"
                                },
                                "local": {
                                    "type": "file",
                                    "path": "main/lighttpd/lighttpd.pre-upgrade"
                                }
                            },
                            {
                                "remote": {
                                    "type": "git",
                                    "commit": {
                                        "hash": "1016b47723",
                                        "tag": "v3.16.3"
                                    },
                                    "url": "git://git.alpinelinux.org/aports",
                                    "path": "main/lighttpd/lighttpd.initd"
                                },
                                "local": {
                                    "type": "file",
                                    "path": "main/lighttpd/lighttpd.initd"
                                }
                            },

```
# Source code 

Bom resolver downloads all source code required to re-build, enabling complete scanning of code, contributions and patches. 



```
        ├── lighttpd
        │   ├── APKBUILD
        │   ├── lighttpd-1.4.64.tar.xz
        │   ├── lighttpd.conf
        │   ├── lighttpd.confd
        │   ├── lighttpd.initd
        │   ├── lighttpd.logrotate
        │   ├── lighttpd.pre-install
        │   ├── lighttpd.pre-upgrade
        │   ├── mime-types.conf
        │   ├── mod_cgi.conf
        │   ├── mod_fastcgi.conf
        │   └── mod_fastcgi_fpm.conf

```



## Vulnerabilities 

For each release, all security fixes are listed in the APKBUILD 

```
# secfixes:
#   1.4.64-r0:
#     - CVE-2022-22707


```

This information is extracted and added to the complete SBOM. 



```json
    "secfixes": {
                        "secfixes": {
                            "1.4.64-r0": [
                                "CVE-2022-22707"
                            ]
                        }
                    }
```


## Licenses  

Combined with the software composition information, the legal impact could be analyzed in the right context. 

- Is there any business critical internal code linked against a restrictive license ? 
- Is this the software used as a command only ? 
- Any patches applied during the build process ?

 

```json
  {
  "license": "BSD-3-Clause"
  }
```



# Providence 

The output could be further checked against [OSSKB](https://osskb.org/)

Below lighttpd version 1.4..67 contains the core file ( server.c ) with hash 03a1d48410609b2bbd1ef7f01518e8f3 

that is used by other linux vendors such as 

- fedora
- opensuse 
- redhat 
- debian 

This information is not needed for rebuild, but for legal and security analyze it contain usefule information 

There are also other services that gather commit history. Commit id connected to users could also be checked against social media to find more about the contributer 



```
# unpack the source package and then create fingerprint for everything inside lighttpd-1.4.64.tar.xz


src/server.c": [
    {
      "component": "lighttpd1.4",
      "file": "server.c",
      "file_hash": "03a1d48410609b2bbd1ef7f01518e8f3",
      "file_url": "https://osskb.org/api/file_contents/03a1d48410609b2bbd1ef7f01518e8f3",
      "id": "file",
      "latest": "1.4.67",
      "licenses": [
        {
          "checklist_url": "https://www.osadl.org/fileadmin/checklists/unreflicenses/BSD-3-Clause.txt",
          "copyleft": "no",
          "name": "BSD-3-Clause",
          "osadl_updated": "2023-01-09T15:58:00+00:00",
          "patent_hints": "no",
          "source": "component_declared",
          "url": "https://spdx.org/licenses/BSD-3-Clause.html"
        },
        {
          "checklist_url": "https://www.osadl.org/fileadmin/checklists/unreflicenses/MIT.txt",
          "copyleft": "no",
          "name": "MIT",
          "osadl_updated": "2023-01-09T15:58:00+00:00",
          "patent_hints": "no",
          "source": "license_file",
          "url": "https://spdx.org/licenses/MIT.html"
        },
        {
          "checklist_url": "https://www.osadl.org/fileadmin/checklists/unreflicenses/BSD-3-Clause.txt",
          "copyleft": "no",
          "name": "BSD-3-Clause",
          "osadl_updated": "2023-01-09T15:58:00+00:00",
          "patent_hints": "no",
          "source": "license_file",
          "url": "https://spdx.org/licenses/BSD-3-Clause.html"
        },
        {
          "checklist_url": "https://www.osadl.org/fileadmin/checklists/unreflicenses/BSD-3-Clause.txt",
          "copyleft": "no",
          "name": "BSD-3-Clause",
          "osadl_updated": "2023-01-09T15:58:00+00:00",
          "patent_hints": "no",
          "source": "scancode",
          "url": "https://spdx.org/licenses/BSD-3-Clause.html"
        }
      ],
      "lines": "all",
      "matched": "100%",
      "oss_lines": "all",
      "purl": [
        "pkg:github/lighttpd/lighttpd1.4",
        "pkg:rpm/fedora/lighttpd",
        "pkg:rpm/opensuse/lighttpd",
        "pkg:deb/debian/lighttpd",
        "pkg:deb/ubuntu/lighttpd",
        "pkg:github/lighttpd/lighttpd2"
      ],
      "release_date": "2022-08-07",
      "server": {
        "kb_version": {
          "daily": "23.02.08",
          "monthly": "23.01"
        },
        "version": "5.2.3"
      },
      "source_hash": "03a1d48410609b2bbd1ef7f01518e8f3",
      "status": "pending",
      "url": "https://github.com/lighttpd/lighttpd1.4",
      "url_hash": "691da43b083dfe143df300a09b88f2fc",
      "vendor": "lighttpd",
      "version": "lighttpd-1.4.66"
    }
  ],

```



The source code is hosted on [Github](https://github.com/Nordix/bomres).

