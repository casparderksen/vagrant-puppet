# Role for hyperledger development box.

class roles::hyperledger {

    # Generic supporting roles
    include profiles::base
    include profiles::tools

    # Docker
    include profiles::docker
    include profiles::docker::swarm

    # Node development
    # include profiles::node::node8

    # Hyperledger
    #include profiles::hyperledger::composer
    include profiles::hyperledger::fabric
}
