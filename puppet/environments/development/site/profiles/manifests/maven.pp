# Installs and configures Apache Maven.
#
# Expects tarball at `puppet:///files/maven/apache-maven-${version}-bin.tar.gz`
#
# A master password for Maven is stored in `/home/${user}/.m2/settings-security.xml`
# To encrypt a master password, run `mvn --encrypt-master-password`.
# This will prompt for the password and print an obfuscated password.
# Encrypt the output with `eyaml encrypt -s '<obfuscated-password>'`.
# Configure the result as eyaml secret `profiles::maven::master_password`.
#
# @param master_password
#   the master password

class profiles::maven(
    String $master_password = undef,
) {
    notice("applying profiles::maven")

    $version = '3.5.3'
    $archive = "apache-maven-${version}-bin.tar.gz"
    $local_file = "/var/tmp/${archive}"    
    $user = 'vagrant'
    $group = 'vagrant'
    $home_dir = "/home/${user}"

    file { $local_file:
        source  => "puppet:///files/tools/${archive}",
    }

    class { 'maven::maven':
        version => $version,
        require => File[$local_file]
    }

    maven::settings { "${home_dir}/.m2/settings.xml":
        user  => $user,
        group => $group,
    }

    $settings_security_xml = @("EOT")
    <settingsSecurity>
        <master>$master_password</master>
    </settingsSecurity>
    |EOT

    file { "${home_dir}/.m2/settings-security.xml":
        owner   => $user,
        group   => $group,
        mode    => '0600',
        content => $settings_security_xml,
    }

    maven::environment { "${home_dir}/.mavenrc":
        user       => $user,
        group      => $group,
        maven_opts => '-Xmx1024m',
    }
}
