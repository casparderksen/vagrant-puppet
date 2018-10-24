# Installs tools and utilities.

class profiles::tools {
    notice("applying profiles::tools")

    $packages = [
        'bash-completion',
        'git-core',
        'git-extras',
        'git-lfs',
        'git-tools',
        'gitflow',
        'graphviz',
        'jq',
        'lsof',
        'man',
        'man-pages',
        'net-tools',
        'rsync',
        'screen',
        'strace',
        'sysstat',
        'vim-enhanced',
        'wget',
        'zip',
        'unzip',
    ]

    $packages.each |$package| {
        package { $package:
            ensure => present,
        }
    }
}
