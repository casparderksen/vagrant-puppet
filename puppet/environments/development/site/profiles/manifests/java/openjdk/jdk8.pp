# Installs OpenJDK 1.8.
#
# Latest version based on available RPMs is selected.

class profiles::java::openjdk::jdk8 {
    
    notice("applying profiles::java::openjdk::jdk8")

    # Install OpenJDK package

    package {'java-1.8.0-openjdk-headless':
        ensure => present,
    }

    # Configure shell environment

    $java_profile = @(EOT)
        # /etc/profile.d/java.sh - Managed by Puppet - do not change
        export JAVA_HOME=$(type -p java | xargs readlink -f | xargs dirname | xargs dirname)
        |EOT

    file { '/etc/profile.d/java.sh':
        content => $java_profile,
    }
}
