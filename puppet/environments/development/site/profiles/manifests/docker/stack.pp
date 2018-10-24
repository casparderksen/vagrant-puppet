# Launches Docker application stack.
#
# @param build_dir
#   local copy of Docker files. Compose files are expected in <build_dir>/stack/<name>/docker-compose.yaml
#
# @param secrets_dir
#   directory for storing Docker Stack secrets

class profiles::docker::stack(
    $build_dir      = undef,
    $secrets_dir    = undef,
) {
    notice("applying profiles::docker::stack")

    # Create directory for storing secrets

    file { $secrets_dir:
        ensure  => directory,
        mode    => '0750',
        group   => 'wheel', # for vagrant access
    }

    # Create secrets files

    $secrets = [
        {
            name => 'maven-master-password',
            key  => 'profiles::maven::master_password',
        },
        {
            name => 'jenkins-user',
            key  => 'profiles::docker::jenkins::admin_user',
        },
        {
            name => 'jenkins-password',
            key  => 'profiles::docker::jenkins::admin_password',
        },
    ]

    $secrets.each |$secret| {
        $file_name = "${secret[name]}"
        $hiera_key = "${secret[key]}"

        file { "${secrets_dir}/${file_name}":
            content => lookup($hiera_key),
            mode    => '0640',
            group   => 'wheel', # for vagrant access
            require => File[$secrets_dir],
        }
    }

    ### Deploy stack

    docker::stack { 'devbox':
        ensure       => present,
        stack_name   => 'devbox',
        compose_file => "${build_dir}/stack/devbox/docker-compose.yaml",
        require      => [
            Class['docker'], 
            File[$stack_dir],
            Docker::Image['my/jenkins'],
            Docker::Image['my/nginx'],
            Docker::Image['my/oracle-12201'],
            Docker::Image['my/weblogic-12213'],
        ]
    }
}
