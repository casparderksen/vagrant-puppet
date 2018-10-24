# Configures Apache HTTPD reverse proxy for Kibana.
#
# TODO https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html

class profiles::apache::kibana(
    $user     = 'kibana',
    $password = undef,
) {

    # Install Apache HTTPD

    class { 'apache': 
        default_vhost  => false,
    }

    # Allow Apache networking in SELinux 

    selboolean { 'httpd_can_network_connect':
        persistent => true,
        value      => 'on',
    }

    # Create password file

    $htpasswd_file = "${::apache::conf_dir}/kibana.htpasswd"
    $password_hash = apache_pw_hash($password)
    
    file { $htpasswd_file:
        content => "${user}:${password_hash}",
        require => Class['apache'],
    }

    # Create TLS key and certificate

    $ssl_cert = '/etc/pki/tls/certs/kibana.localdomain.crt'
    $ssl_key  = '/etc/pki/tls/private/kibana.localdomain.key'

    file { $ssl_cert:
        source  => 'puppet:///files/tls/certs/kibana.localdomain.crt',
        mode    => '0644',
    }

    file { $ssl_key:
        source  => 'puppet:///files/tls/private/kibana.localdomain.key',
        mode    => '0400',
        owner   => 'apache'
    }

    # Configure virtual host

    $auth_htpasswd = @("EOT")
        <Proxy *>
            Order allow,deny
            Allow from all
            AuthName 'Kibana'
            AuthType Basic
            AuthBasicProvider file
            AuthUserFile $htpasswd_file
            Require valid-user
        </Proxy>
        |EOT

    apache::vhost { 'kibana':
        port       => 443,
        docroot    => '/var/www/html',
        ssl        => true,
        ssl_cert   => $ssl_cert,
        ssl_key    => $ssl_key,
        proxy_pass => { 
            path => '/', 
            url  => 'http://127.0.0.1:5601/',
        },
        custom_fragment => $auth_htpasswd,
        require         => [ File[$htpasswd_file], File[$ssl_cert], File[$ssl_key] ]
    }
}
