# Logstash pipeline for processing all beats inputs.
#
# @param elasticsearch_urls
#     Elasticsearch cluster entry points

class profiles::elk::logstash::pipelines::beats(
    Array[String] $elasticsearch_urls = undef,
) {
    $quoted_elastic_search_urls = $elasticsearch_urls.map |$url| { "\"${url}\"" }

    $beats_conf = @("EOT")
        input {
            beats {
                port => 5044
            }
        }

        filter {
            if [fields][type] == "weblogic" {
                grok {
                    patterns_dir => ["/etc/logstash/patterns"]
                    match => ["message", "%{WLS_SRV_LOG}"]
                }
                date {
                    match => [ "wls_timestamp", "MMM dd, yyyy h:m:s,SSS a 'CEST'" ]
                    remove_field => [ 'wls_timestamp' ]
                }
                # TODO map wls_bea_id to error.code and drop
                # TODO map wls specific field to wls key when required
            }
        }

        output {
            elasticsearch {
                hosts => ${quoted_elastic_search_urls}
                manage_template => false
                index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
            }
            stdout { codec => rubydebug }
        }
        |EOT

    logstash::configfile { 'beats.conf':
        content => sprintf("### Managed by Puppet - do not edit\n%s", $beats_conf),
    }
}
