#!/bin/sh

docker login container-registry.oracle.com

read -d '' IMAGES <<EOF
container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev
container-registry.oracle.com/database/enterprise:12.2.0.1-slim
EOF

for IMAGE in $IMAGES; do
      echo "==> DOCKER IMAGE: $IMAGE"
      echo
      docker pull $IMAGE
done

echo "===> SAVING IMAGES"
docker save container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev | gzip - > /vagrant/files/images/weblogic-12213-dev.tgz
docker save container-registry.oracle.com/database/enterprise:12.2.0.1-slim | gzip - > /vagrant/files/images/oracle-12201-slim.tgz
