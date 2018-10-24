# Configures shell environment for users

class profiles::elk::elasticsearch::profile {

      $elasticsearch_profile = @(EOT)
            # /etc/profile.d/elasticsearch.sh - Managed by Puppet - do not edit
            export ES_PATH_CONF=/etc/elasticsearch
            export ES_HOME=/usr/share/elasticsearch
            export PATH=$PATH:$ES_HOME/bin
            |EOT

      file { '/etc/profile.d/elasticsearch.sh':
            content => $elasticsearch_profile,
      }
}
