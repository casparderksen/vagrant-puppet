# Installs Elasticsearch Coordinating Only Node.
#
# @param instance_name
#  instance name
#
# @param cluster_name
#  cluster name (unique across environments)
#
# @param node_name
#   node name (defaults to host name)
#
# @param network_host
#  network bind address
#
# @param jvm_options
#   JVM options
#
# @param data_dir
#   data directory
#
# @param seed_nodes
#   elasticsearch nodes for finding the cluster

class profiles::elk::elasticsearch_con(
    String        $instance_name  = 'es-01',
    String        $cluster_name   = undef,
    String        $node_name      = $hostname,
    String        $network_host   = '127.0.0.1',
    Array[String] $jvm_options    = ['-Xms1g', '-Xmx1g'],
    String        $data_dir       = '/var/lib/elasticsearch',
    Array[String] $seed_nodes     = undef,
) {
    # Setup elasticsearch user and group
    class { profiles::elk::users::elasticsearch:
        gid => 920,
        uid => 920,
    }

    # Install Elasticsearch package
    class { profiles::elk::elasticsearch::install: 
        data_dir => $data_dir, 
    }

    # Configure instance
    elasticsearch::instance { $instance_name:
        config => {
            'cluster.name'                     => $cluster_name,
            'node.name'                        => $node_name,
            'network.host'                     => $network_host,
            'bootstrap.memory_lock'            => true,
            'discovery.zen.ping.unicast.hosts' => $seed_nodes,
            'node.master'                      => false,
            'node.data'                        => false,
            'node.ingest'                      => false,
            'search.remote.connect'            => false,
        },
        jvm_options => $jvm_options,
    }

    # Configure Systemd service override
    class { profiles::elk::elasticsearch::service:
        instance_name => $instance_name,
    }

    # Configure shell environment for users
    class { profiles::elk::elasticsearch::profile: }
}
