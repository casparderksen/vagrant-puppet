# Installs Kibana.
#
# Kibana should connect to a local Elasticsearch instance (not master or data node) that joins the cluster.
#
# @param server_host
#   host of backend server
#
# @param server_name
#   display name for Kibana instance
#
# @param elasticsearch_url
#   url of Elasticsearch node (default: http://localhost:9200)

# TODO https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-settings.html
# Client ES node https://www.elastic.co/guide/en/kibana/current/production.html


class profiles::elk::kibana(
    String $server_host         = '127.0.0.1',
    String $server_name         = $hostname,
    String $data_dir          = '/var/lib/kibana',
    String $elasticsearch_url     = 'http://localhost:9200',
) {
    # Setup kibana user and group
    class { profiles::elk::users::kibana:
        gid => 922,
        uid => 922,
    }

    # Install Kibana

    class { 'kibana' :
        manage_repo => false,
        config => { 
            'path.data'       => $data_dir,
            'server.host'     => $server_host,
            'server.name'     => $server_name,
            'elasticsearch.url' => $elasticsearch_url,
        }
    }

    # Configure plugins

    #kibana_plugin { 'x-pack': }
}
