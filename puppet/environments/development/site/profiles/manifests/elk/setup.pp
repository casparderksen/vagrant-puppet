# Setup for index templates and dashboards.
#
# @param elasticsearch_hosts
#     host and port for connecting to elasticsearch (default: localhost:9200)

class profiles::elk::setup(
    String $elasticsearch_host = "localhost:9200",
) {
    # Setup Filebeat script

    $setup_filebeat = @("EOT")
        #!/bin/sh -x

        # Setup Filebeat index template and dashboards
        /bin/filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["${elasticsearch_host}"]'
        /bin/filebeat setup --dashboards
        |EOT

    file { '/usr/local/bin/setup-filebeat': 
        content => $setup_filebeat,
        mode    => '0755',
    }

    # Setup Metricbeat script

    $setup_metricbeat = @("EOT")
        #!/bin/sh -x

        # Setup Metricbeat index template and dashboards
        /bin/metricbeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["${elasticsearch_host}"]'
        /bin/metricbeat setup --dashboards
        |EOT

    file { '/usr/local/bin/setup-metricbeat': 
        content => $setup_metricbeat,
        mode    => '0755',
    }
}
