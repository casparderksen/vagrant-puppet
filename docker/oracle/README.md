# Oracle official containers

Login to Oracle Container Registry:
    
    $ docker login container-registry.oracle.com

Pull images:

    $ docker pull container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev
    $ docker pull container-registry.oracle.com/database/enterprise:12.2.0.1-slim

Saving images:

    $ docker save container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev | gzip - > /vagrant/files/images/weblogic-12213-dev.tgz
    $ docker save container-registry.oracle.com/database/enterprise:12.2.0.1-slim | gzip - > /vagrant/files/images/oracle-12201-slim.tgz

Load images:

    $ zcat /vagrant/files/images/weblogic-12213-dev.tgz | docker load
    $ zcat /vagrant/files/images/oracle-12201-slim.tgz | docker load

Tag images:

    $ docker tag container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev oracle/weblogic:12.2.1.3-dev
    $ docker tag container-registry.oracle.com/database/enterprise:12.2.0.1-slim oracle/database:12.2.0.1-slim

The script `pull-oracle-images.sh` automates the pull and save process. 
A Puppet profile automates loading and tagging images from Puppet builds.

# References

## Oracle Container Registry

See `https://container-registry.oracle.com/` for the Oracle Container Registry.
See `https://docs.oracle.com/cd/E37670_01/E75728/html/oracle-registry-server.html` for using the Oracle Container Registry.

## Weblogic on Docker

See `https://github.com/oracle/docker-images/tree/master/OracleWebLogic`

## Oracle database on Docker

See `https://github.com/oracle/docker-images/tree/master/OracleDatabase`