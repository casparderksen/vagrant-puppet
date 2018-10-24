# Role for ELK stack.

class roles::elk {

    # Server baseline
    include profiles::base

    # Java
    include profiles::java::openjdk::jdk8

    # ELK
    include profiles::elk::repo
    include profiles::elk::elasticsearch
    include profiles::elk::curator
    include profiles::elk::logstash
    include profiles::elk::logstash::pipelines::beats
    include profiles::elk::logstash::patterns::weblogic
    include profiles::elk::kibana

    # Beats
    include profiles::elk::filebeat
    include profiles::elk::filebeat::prospectors::weblogic
    include profiles::elk::metricbeat

    # One time setup scripts (run manually)
    include profiles::elk::setup

    # Apache
    include profiles::apache::kibana
}
