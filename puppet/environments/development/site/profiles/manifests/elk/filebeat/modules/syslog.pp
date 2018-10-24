# Enable filebeat syslog module

class profiles::elk::filebeat::modules::syslog {

    exec { '/bin/filebeat modules enable system': 
        creates => '/etc/filebeat/modules.d/system.yml',
        require => Package['filebeat'],
        notify  => Service['filebeat'],
    } 
}
