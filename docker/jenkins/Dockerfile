FROM jenkins/jenkins:lts

USER root

# Install Apache Maven

ARG MAVEN_VERSION=3.5.3
ARG MAVEN_SHA=b52956373fab1dd4277926507ab189fb797b3bc51a2a267a193c931fffad8408
ARG MAVEN_BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    echo "${MAVEN_SHA} /tmp/apache-maven.tar.gz" | sha256sum -c - && \
    tar -xzf /tmp/apache-maven.tar.gz -C /opt && \
    rm -f /tmp/apache-maven.tar.gz

# Install Oracle JDK8

ARG JAVA_URL=http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz

RUN curl -fsSLjk -H "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jdk8.tar.gz ${JAVA_URL} && \
    mkdir -p /usr/java && \
    tar -xzf /tmp/jdk8.tar.gz -C /usr/java && \
    rm -f /tmp/jdk8.tar.gz

USER jenkins

# Install custom plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Skip Jenkins setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Set context path for running behind reverse proxy
ENV JENKINS_OPTS="--prefix=/jenkins"

# Add run-time initialization scripts
COPY groovy/* /usr/share/jenkins/ref/init.groovy.d/
