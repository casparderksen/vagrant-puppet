# Installs Docker daemon.

class profiles::docker {
    notice("applying profiles::docker")

    # Install Docker daemon and add vagrant to docker group
    class { 'docker':
        docker_users => ['vagrant'],
    }

    # Add cleanup script

    $docker_clean_script = @(EOT)
        #!/bin/sh

        # Stop and remove all stacks
        docker stack ls | tail -n +2 | awk '{print $1}' | xargs --no-run-if-empty docker stack rm

        # Stop and remove all containers
        docker ps -a -q | xargs --no-run-if-empty docker stop
        docker ps -a -q | xargs --no-run-if-empty docker rm

        # Remove untagged images
        docker images | tail -n +2 | awk '$1 == "<none>" {print $3}' | xargs --no-run-if-empty docker rmi
        |EOT


    file { "/usr/local/bin/docker-clean":
        mode    => '0755',
        content => $docker_clean_script,
    }
}
