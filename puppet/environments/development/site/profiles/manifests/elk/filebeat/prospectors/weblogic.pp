# Filebeat prospector for Weblogic.
#
# Custom logs must provide 'application' and 'type' fields.
#
# TODO 
# - configure WLS paths
# - add access.log

class profiles::elk::filebeat::prospectors::weblogic {

    $wls_prospector_conf = @(EOT)
        - type: log
          paths:
            - /u01/app/oracle/config/domains/mydomain/servers/AdminServer/logs/mydomain.log
          fields:
            application: weblogic
            type: weblogic
          multiline.pattern: '^####'
          multiline.negate: true
          multiline.match: after
        |EOT

    file { '/etc/filebeat/prospectors.d/weblogic.yml':
        content => $wls_prospector_conf,
        ensure  => present,
        replace => 'no', # user managed for now
        mode    => '0644',
        require => File['/etc/filebeat/prospectors.d'], 
        notify  => Service['filebeat'],
    }
}
