# Build container images.
#
# @param build_dir
#   local copy of docker source files for building images

class profiles::docker::build(
    String $build_dir = undef,
) {
    notice("applying profiles::docker::build")

    file { $build_dir:
        ensure  => directory,
        recurse => true,
        source  => 'puppet:///docker/',
    }

    $images = [
        {
            dir => 'jenkins',
            tag => 'my/jenkins',
        },
        {
            dir => 'nginx',
            tag => 'my/nginx',
        },
        {
            dir => 'oracle/oracle-12201',
            tag => 'my/oracle-12201',
        },
        {
            dir => 'oracle/weblogic-12213',
            tag => 'my/weblogic-12213',
        },
    ]

    $images.each | $image | {
        $dir = "${image[dir]}"
        $tag = "${image[tag]}"
        $docker_dir = "${build_dir}/${dir}"

        docker::image { $tag:
            docker_dir => $docker_dir,
            require    => [Class['docker'], File[$build_dir]],
        }
    }
}
