# Installs Elasticsearch.
#
# For disabling swapping we configure 'bootstrap.memory_lock: true'.
# This requires 'LimitMEMLOCK=infinity' in the Systemd configuration.
# To check memory locking setting: GET _nodes?filter_path=**.mlockall
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

# TODO 
# - snapshots/backup
# - TLS

class profiles::elk::elasticsearch(
    String        $instance_name  = 'es-01',
    String        $cluster_name   = undef,
    String        $node_name      = $hostname,
    String        $network_host   = '127.0.0.1',
    Array[String] $jvm_options    = undef,
    String        $data_dir       = '/var/lib/elasticsearch',
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
            'cluster.name'          => $cluster_name,
            'node.name'             => $node_name,
            'network.host'          => $network_host,
            'bootstrap.memory_lock' => true,
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
