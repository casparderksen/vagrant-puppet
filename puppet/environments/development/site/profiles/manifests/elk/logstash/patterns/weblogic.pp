# Logstash patterns for Weblogic.
#
# TODO: replace DATA with more specific patterns to prevent backtracking

class profiles::elk::logstash::patterns::weblogic {

    # logstash::patternfile { 'extra_patterns':
    #       source => 'puppet:///path/to/extra_patterns',
    # }

    $weblogic_patterns = @(EOT)
        # Weblogic server logs
        WLS_SRV_LOG_FMT1 ^####<%{DATA:wls_timestamp}> <%{LOGLEVEL:severity}> <%{WORD}> <%{HOSTNAME}> <(%{WORD})?> <%{DATA}> <%{DATA:principal}> <%{DATA}> <%{DATA}> <%{NUMBER}> <\[severity-value: %{NUMBER}\] \[rid: %{NUMBER}\] \[partition-id: %{NUMBER}\] \[partition-name: %{DATA}\] > <%{WORD:wls_bea_id> %{GREEDYDATA:log_message}
        WLS_SRV_LOG %{WLS_SRV_LOG_FMT1}
        |EOT

    file { '/etc/logstash/patterns/weblogic':
        content => $weblogic_patterns,
        ensure  => present,
        replace => 'no', # user managed for now
        mode    => '0644',
        require => Package['logstash'],
        notify  => Service['logstash'],
    }
}
