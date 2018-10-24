# Installs Oracle JDK 1.8.
#
# Expects RPM at `puppet:///files/jdk/jdk-${version}-linux-x64.rpm`
# Latest version based on available RPMs is selected.

class profiles::java::oracle::jdk8 {
    notice("applying profiles::java::oracle::jdk8")

    include profiles::yumrepo

    # Create local Yum repo
    
    profiles::yumrepo::local_repo { 'jdk.repo': 
        repo_name => 'jdk',
    }

    # Install Oracle JDK package

    package {'jdk1.8':
        ensure => present,
    }

    # Configure shell environment

    $java_profile = @(EOT)
        # /etc/profile.d/java.sh - Managed by Puppet - do not change
        export JAVA_HOME=/usr/java/latest
        |EOT

    file { '/etc/profile.d/java.sh':
        content => $java_profile,
    }
}
