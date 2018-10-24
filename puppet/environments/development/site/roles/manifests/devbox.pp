# == Class: roles::default
#
# Role for development box.

class roles::devbox {

    # Generic supporting roles
    include profiles::base
    include profiles::tools
    include profiles::yumrepo

    # Puppet
    include profiles::puppet
    include profiles::pdk

    # Packer
    include profiles::packer

    # Docker
    include profiles::docker
    include profiles::docker::pull
    include profiles::docker::load
    include profiles::docker::build
    include profiles::docker::swarm
    include profiles::docker::stack

    # ELK
    #include profiles::elk::elasticsearch
    #include profiles::elk::logstash
    #include profiles::elk::kibana
    #include profiles::elk::filebeats
    #include profiles::java::openjdk::jdk8

    # Java development
    include profiles::java::oracle::jdk8
    include profiles::maven

    # Node development
    include profiles::node::node8
    include profiles::node::packages

    # Oracle client
    include profiles::instantclient

    # Hyperledger
    #include profiles::hyperledger::composer
    #include profiles::hyperledger::fabric

    # Apache
    #include profiles::apache
}
