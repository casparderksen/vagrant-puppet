# Configure Systemd service override.
#
# For disabling swapping we configure 'bootstrap.memory_lock: true'.
# This requires 'LimitMEMLOCK=infinity' in the Systemd configuration.
# To check memory locking setting: GET _nodes?filter_path=**.mlockall
#
# @param instance_name
#  instance name

class profiles::elk::elasticsearch::service(
      String $instance_name = undef,
) {
      $service_overrides_conf = @(EOT)
            # Managed by Puppet - do not edit
            [Service]
            LimitMEMLOCK=infinity
            |EOT

      file { "/etc/systemd/system/elasticsearch-${instance_name}.service.d/service-overrides.conf":
            content => $service_overrides_conf,
            require => File["/etc/systemd/system/elasticsearch-${instance_name}.service.d"],
      } 
      ~> Elasticsearch::Instance[$instance_name]

      file { "/etc/systemd/system/elasticsearch-${instance_name}.service.d":
            ensure => directory,
      }
}
