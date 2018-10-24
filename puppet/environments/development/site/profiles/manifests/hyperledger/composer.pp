# Installs Hyperledger Composer and Composer Playground.

class profiles::hyperledger::composer {
    notice("applying profiles::hyperledger::composer")

     # Install NPM global packages

    $packages = [
        'composer-cli',
        'composer-playground',  
        'composer-rest-server',
        'generator-hyperledger-composer',
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
