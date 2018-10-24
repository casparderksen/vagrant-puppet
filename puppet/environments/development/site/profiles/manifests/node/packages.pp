# Installs Node global packages.

class profiles::node::packages {
    notice("applying profiles::node::packages")

    $packages = [
        'angular-cli',
        'bower',
        'browserify',
        'eslint',
        'express-generator',
        'grunt-cli',
        'less',
        'protractor',
        'typescript',
        'yo',
    ]

    $packages.each |$package| {
        package { $package:
            ensure   => present,
            provider => 'npm',
            install_options => [ '--unsafe-perm' ],
            require  => Class['nodejs'],
        }
    }
}
