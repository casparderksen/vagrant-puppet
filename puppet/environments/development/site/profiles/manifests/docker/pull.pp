# Pulls docker images for pre-packaging a development box.

class profiles::docker::pull {
    notice("applying profiles::docker::pull")

    $images = [
        'centos:7',
        'jenkins/jenkins:lts',
        'jboss/wildfly',
        'nginx',
        'registry',
        'owasp/zap2docker-stable',
        'webgoat/webgoat-7.1',
        'docker.elastic.co/elasticsearch/elasticsearch:6.2.3',
        'docker.elastic.co/kibana/kibana:6.2.3',
        'docker.elastic.co/logstash/logstash:6.2.3',
        'docker.elastic.co/beats/filebeat:6.2.3',
    ]

    $images.each |$image| {
        docker::image { $image: }
    }
}
