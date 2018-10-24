# Installs Curator.
#
# Curator can be deployed on all elasticsearch nodes and is configured to run on the elected master only.

class profiles::elk::curator(
    String $host = '127.0.0.1',
) {

    $conf_dir = '/etc/curator'
    $curator_conf_yml = "${conf_dir}/curator.yml"
    $actions_conf_yml = "${conf_dir}/actions.yml"

    $log_dir = '/var/log/curator'
    $log_file = "${log_dir}/curator.log"

    # Install Curator 

    package { 'elasticsearch-curator':
        ensure  => present,
    }

    file { $conf_dir:
        ensure  => directory,
        mode    => '0644',
    }

    file { $log_dir:
        ensure  => directory,
        mode    => '0644',
    }

    # Configure Curator

    $curator_conf = {
        'client' => {
            'hosts'       => $host,
            'master_only' => 'True',
        },
        'logging' => {
            'logfile'     => $log_file,
        }
    }

    file { $curator_conf_yml:
        content => sprintf("### Managed by Puppet - do not edit\n%s", $curator_conf.to_yaml),
        mode    => '0644',
        require => File[$conf_dir],
    }

    # Configure management actions

    $actions_conf = {
        actions => {
            '1' => {
                'action'  => 'delete_indices',
                'options' => {
                    'ignore_empty_list' => 'True',
                },
                filters => [
                    {
                        'filtertype' => 'pattern',
                        'kind'       => 'regex',
                        'value'      => '^(filebeat-|metricbeat-|logstash-).*$',
                    },
                    {
                        'filtertype' => 'age',
                        'source'     => 'name',
                        'direction'  => 'older',
                        'timestring' => '%Y.%m.%d',
                        'unit'       => 'days',
                        'unit_count' => 14,
                    }
                ]
            }
        }
    }

    file { $actions_conf_yml:
        content => sprintf("### Managed by Puppet - do not edit\n%s", $actions_conf.to_yaml),
        mode    => '0644',
        require => File[$conf_dir],
    }

    # Schedule Cron job for running Curator

    cron { 'curator':
        ensure  => 'present',
        command => "/bin/curator --config ${curator_conf_yml} ${actions_conf_yml}",
        hour    => 1,
        minute  => 10,
        weekday => '*',
    }

    # Configure logrotate for Curator logs

    $logrotate_conf = @("EOT")
        $log_file {
            daily
            rotate 14
            copytruncate
            notifempty
            missingok
            compress
        }
        |EOT

    file { '/etc/logrotate.d/curator':
        content => sprintf("### Managed by Puppet - do not edit\n%s", $logrotate_conf),
        mode    => '0644',
    }
}
