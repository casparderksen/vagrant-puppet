# Installs Logstash.
#
# Note: Logstash should not connect directly to master nodes that perform cluster management.
# For scaling, configure a shipping and indexing instances with intermediate message broker.
#
# @param node name
#   node name (defaults to hostname)
#
# @param http_host
#   network bind address
#
# @param jvm_options
#   JVM options
#
# @param data_dir
#   data directory (persistent queues)

class profiles::elk::logstash(
    String      $node_name        = $hostname,
    String      $http_host        = '127.0.0.1',
    Array[String] $jvm_options        = undef,
    String      $data_dir         = '/var/lib/logstash',
) {
    # Setup logstash user and group
    class { profiles::elk::users::logstash:
        gid => 921,
        uid => 921,
    }

    # Install Logstash

    class { 'logstash':
        manage_repo     => false,
        purge_config    => false,
        restart_on_change => true,
        jvm_options     => $jvm_options,
        settings => {
            'node.name'            => $node_name,
            'http.host'            => $http_host,
            'http.port'            => '9600',
            'path.data'            => $data_dir,  
            'queue.type'           => 'persisted',
            'dead_letter_queue.enable' => true,
        },
        pipelines => [
            {
                "pipeline.id" => "pipeline_beats",
                "path.config" =>  "/etc/logstash/conf.d/beats.conf",
            },
        ]
    }

    # Install plugins

    logstash::plugin { 'logstash-input-beats': }

    # Configure shell environment for users

    $logstash_profile = @(EOT)
        # /etc/profile.d/logstash.sh - Managed by Puppet - do not edit
        export LS_HOME=/usr/share/logstash
        export PATH=$PATH:$LS_HOME/bin
        |EOT

    file { '/etc/profile.d/logstash.sh':
        content => $logstash_profile,
    }

    # Schedule Cron job for removing old log files

    cron { 'logstash':
        ensure  => 'present',
        command => "find /var/log/logstash -type f -mtime +14 -delete",
        hour    => 1,
        minute  => 10,
        weekday => '*',
    }
}
