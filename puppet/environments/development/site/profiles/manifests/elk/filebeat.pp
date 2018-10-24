# Installs Filebeat.
#
# @param kibana_host
#   Kibana host for setting up dashboards
#
# @param logstash_hosts
#   Logstash hosts
#
# @param log_paths
#   paths to monitor
#
# Load index template manually: 
#   filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'
# Setup dashboards:
#   filebeat setup --dashboards

class profiles::elk::filebeat(
    String        $kibana_host     = undef,
    Array[String] $logstash_hosts = undef,
) {
    # Install Filebeat 

    package {'filebeat':
        ensure => present,
    }

    # Configure Filebeat

    $filebeat_conf = {
        'filebeat.config.prospectors' => {
            'enabled'        => true,
            'path'           => 'prospectors.d/*.yml',
            'reload.enabled' => true,
            'reload.period'  => '60s',
        },
        'filebeat.config.modules' => {
            'path'           => '${path.config}/modules.d/*.yml',
            'reload.enabled' => false,
        },
        'setup.template.enabled'  => false,
        'setup.template.settings' => {
            'index.number_of_shards' => 3,
        },
        'setup.kibana' => {
            'host' => $kibana_host,
        },
        'output.logstash' => {
            'hosts' => $logstash_hosts,
        }
    }

    file {'/etc/filebeat/prospectors.d':
        ensure  => directory,
        mode    => '0644',
        require => Package['filebeat'],
    }

    file {'/etc/filebeat/filebeat.yml':
        content => sprintf("### Managed by Puppet - do not edit\n%s", $filebeat_conf.to_yaml),
        mode    => '0644',
        require => Package['filebeat'],
        notify  => Service['filebeat'],
    } ~> 
    exec { '/bin/filebeat test config': }

    # Run Filebeat service

    service { 'filebeat':
        ensure => running,
    }
}
