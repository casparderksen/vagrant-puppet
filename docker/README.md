# Makefile

# Containers

## Jenkins

Automated Jenkins setup:
- Oracle JDK8
- Apache Maven
- Plugins
- Tool configuration
- Users
- Hardening

## Nginx

Reverse proxy for containerized services.

## Oracle

Oracle 12c database and Weblogic Server. Using Weblogic in a container is in my
humble opinion a blatant case of cloud-washing. Management and deployment technology 
of container orchestration tools are far superiour, and not a point solution for Java. 

# Stack

The [`stack/docker-compose.yaml`](stack/docker-compose.yaml) launches a container landscape:
- applications and exposed ports
- volumes for persisted data
- network
- secrets for provisioning and accessing external services

# Secrets

Secrets files are provisioned on the host box by Puppet from encrypted Hiera Eyaml configuration.
In order to prevent storage of secrets, secrets may only be used at run time, and must not be
included in builds. 

For development and testing, containers must not assume existense of secret files, and fall back
to (unsafe) defaults. 

## Example (Jenkins)

See for example [`jenkins/groovy/jenkins-security.groovy`](jenkins/groovy/jenkins-security.groovy).
First we check the environment for the password file, and fall back to a sensible default.
Then we read the password from this file, and fall back to a default for running a single container
without secrets management.

# Dependencies

Open source dependencies for images are downloaded from the `Dockerfile` builds.
Using Oracle containers requires login to the Oracle Container Registry.
In order to automatically provision an immutable development box, and prevent long
downloads (Oracle secretly is a coffee company, its true), these images can be pulled once
and then loaded from local file.

See [`oracle/README.md`](docker/oracle/README.md) on how to pull and save images
from the Oracle Container Repository. Pull and add the following gzipped images:

	files/images/oracle-12201-slim.tgz
	files/images/weblogic-12213-dev.tgz


