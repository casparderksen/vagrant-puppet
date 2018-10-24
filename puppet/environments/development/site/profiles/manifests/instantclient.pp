# Installs Oracle Instant Client.
# OJDBC jars are in `/usr/lib/oracle/12.2/client64/lib`.

class profiles::instantclient {
    notice("applying profiles::instantclient")

    include profiles::yumrepo

    # Create local Yum repo
    profiles::yumrepo::local_repo { 'instantclient.repo': repo_name => 'instantclient' }

    # Install packages
    
    $packages = [
        'oracle-instantclient12.2-basic',
        'oracle-instantclient12.2-jdbc',
        'oracle-instantclient12.2-sqlplus',
    ]

    $packages.each |$package| {
        package { $package:
            ensure => present,
        }
    }

    # Shell profile for instant client

    $instantclient_profile = @(EOT)
        # /etc/profile.d/instantclient.sh - Managed by Puppet - do not change
        export PATH=/usr/lib/oracle/12.2/client64/bin:$PATH
        export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib:$LD_LIBRARY_PATH
        |EOT

    file { '/etc/profile.d/instantclient.sh':
        content => $instantclient_profile,
    }

    # Directory for tnsnames.ora

    $lib_dir = '/usr/lib/oracle/12.2/client64/lib'

    file { "${lib_dir}/network/admin":
        ensure  => directory,
        require => File["${lib_dir}/network"],
    }

    file { "${lib_dir}/network":
        ensure  => directory,
        require => Package['oracle-instantclient12.2-basic'],
    }
}
