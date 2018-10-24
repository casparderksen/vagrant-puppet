# Loads and tags saved Docker images for pre-packaging a development box.

class profiles::docker::load {
    notice("applying profiles::docker::load")

    $images = [
        {
            name => 'container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev',
            tag  => 'oracle/weblogic:12.2.1.3-dev',
            file => 'weblogic-12213-dev.tgz',
        },
        {
            name => 'container-registry.oracle.com/database/enterprise:12.2.0.1-slim',
            tag  => 'oracle/database:12.2.0.1-slim',
            file => 'oracle-12201-slim.tgz',
        },
    ]

    $images.each |$image| {
        $tmp_file = "/var/tmp/${image[file]}"

        file { $tmp_file:
            source  => "puppet:///files/images/${image[file]}",
        } ->
        exec { "zcat ${tmp_file} | docker load":
            path    => ['/usr/bin'],
            unless  => "docker images | tail -n +2 | awk '{OFS=\":\"; print \$1,\$2}' | grep ${image[name]}",
            require => Class['docker'],
        } ->
        exec { "/usr/bin/docker tag ${image[name]} ${image[tag]}": }
    }
}
