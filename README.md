# Vagrant development box for Puppet

This project used a basebox from 
[https://github.com/casparderksen/packer-kickstart-vagrant](https://github.com/casparderksen/packer-kickstart-vagrant).

This project is intended to be used behind a corporate firewall, meaning manual donwload of dependencies.

# Dependencies

Download the following files:

	files/tools/packer_1.2.2_linux_amd64.zip
	files/tools/apache-maven-3.5.3-bin.tar.gz

	files/rpm/jdk-8u162-linux-x64.rpm

	files/rpm/oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm
	files/rpm/oracle-instantclient12.2-jdbc-12.2.0.1.0-1.x86_64.rpm
	files/rpm/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm

	files/rpm/elk/logstash-6.2.4.rpm
	files/rpm/elk/elasticsearch-6.2.4.rpm
	files/rpm/elk/elasticsearch-curator-5.5.4-1.x86_64.rpm
	files/rpm/elk/filebeat-6.2.4-x86_64.rpm
	files/rpm/elk/kibana-6.2.4-x86_64.rpm
	files/rpm/elk/metricbeat-6.2.4-x86_64.rpm

For Oracle Docker images, add the following gzipped images:

	files/images/oracle-12201-slim.tgz
	files/images/weblogic-12213-dev.tgz

See [`docker/oracle/README.md`](docker/oracle/README.md) on how to pull and save images
from the Oracle Container Repository.
