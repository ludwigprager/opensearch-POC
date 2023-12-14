# keycloak-POC

## Description

This project is a keycloak playground to install, configure and run in a kubernetes cluster 
in a matter of minutes without affecting running installations.  
It is self-contained and has a small footprint. The [tear-down script](./90-teardown.sh) will
remove most traces when applied after use.

## TL;DR
Clone this repo and run the start script:

```
git clone --origin github https://github.com/ludwigprager/keycloak-POC.git
./keycloak-POC/10-deploy.sh
```


## Prerequisites
- a linux machine. Any distribution should work fine. Or macOS with Darwin.   
- docker, psql

## How this POC works

TODO

# Script Properties

The bash scripts adhere to the following principles:
- dedicated versions. As opposed to implicit version number, leading to recommended or 'latest'.
- idempotent
- exits on first error
- independent of the caller's working directory
