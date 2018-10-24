# Setup Docker Swarm cluster.
#
# @param advertise_addr 
#   advertise address
# @param listen_addr 
#   listen address

class profiles::docker::swarm(
    String $advertise_addr  = $ipaddress_eth1,
    String $listen_addr     = $ipaddress_eth1,
) {
    notice("applying profiles::docker::swarm")

    docker::swarm { 'manager':
        init           => true,
        advertise_addr => $advertise_addr,
        listen_addr    => $listen_addr,
        require        => Class['docker'],
    }
}
