# Installs Metricbeat.
#
# @param kibana_host
#   Kibana host for setting up dashboards
#
# @param logstash_hosts
#   Logstash hosts

# Load index template manually:
#     metricbeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'
# Setup dashboards:
#     metricbeat setup --dashboards
# Enable system module
#     metricbeat modules enable system

class profiles::elk::metricbeat(
    String      $kibana_host    = undef,
    Array[String] $logstash_hosts = undef,
) {
    # Install Metricbeat 
    
    package {'metricbeat':
        ensure => present,
    }

    # Configure Metricbeat

    $metricbeat_conf = {
        'metricbeat.config.modules' => {
            'path'         => '${path.config}/modules.d/*.yml',
            'reload.enabled' => false,
        },
        'setup.template.enabled' => false,
        'setup.template.settings' => {
            'index.number_of_shards' => 1,
            'index.codec'        => 'best_compression'
        },
        'setup.kibana' => {
            'host' => $kibana_host,
        },
        'output.logstash' => {
            'hosts' => $logstash_hosts,
        }
    }

    file {'/etc/metricbeat/metricbeat.yml':
        content => sprintf("# Managed by Puppet - do not edit\n%s", $metricbeat_conf.to_yaml),
        require => Package['filebeat'],
        notify  => Service['metricbeat'],
    } ~> 
    exec { '/bin/metricbeat test config': }

    # Run Metricbeat service

    service { 'metricbeat':
        ensure => running,
    }
}
