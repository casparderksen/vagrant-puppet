# Sets up a local Yum repository for donwloaded RPMs.

class profiles::yumrepo {
    notice("applying profiles::yumrepo")

    define local_repo(String $repo_name) {

        $repo_dir = "/var/cache/yum/x86_64/7/${repo_name}"

        # Create local directory for repository
        
        file { $repo_dir:
            ensure => directory, 
        }

        # Copy RPM packages to local directory

        file { "${repo_dir}/packages":
            ensure  => directory,
            recurse => true,
            source  => "puppet:///files/rpm/${repo_name}",
            require => File[$repo_dir],
        }

        # Generate meta-data for repository

        exec { "createrepo ${repo_dir}":
            path    => ['/bin'],
            creates => "${repo_dir}/repodata/repomd.xml",
            require => [Package['createrepo'], File["${repo_dir}/packages"]],
        }

        # Create repository config file

        yumrepo { $repo_name:
            ensure   => 'present',
            enabled  => true,
            gpgcheck => false,
            descr    => "Local repository ${repo_name}",
            baseurl  => "file://${repo_dir}",
            require  => Exec["createrepo ${repo_dir}"],
        }
    }

    # Require createrepo package for indexing Yum repositories

    package { 'createrepo': 
        ensure => present,
    }

    # Require Yum repositories before installing other packages
    
    Yumrepo <| |> -> Package <| title != 'createrepo' |>
}
