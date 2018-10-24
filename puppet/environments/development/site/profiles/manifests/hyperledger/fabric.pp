# Pulls Hyperledger Fabric Docker images.

class profiles::hyperledger::fabric {
    notice("applying profiles::hyperledger::fabric")

    $version = "1.1.0"
    $ca_version = $version
    $third_party_version = "0.4.6"

    define pull(Array[String] $images, String $version) {
        $tag = "${architecture}-${version}"

        $images.each |$image| {
            docker::image { "${image}":
                image_tag => "${tag}",
            } ->
            exec { "/usr/bin/docker tag ${image}:${tag} ${image}": }
        }
    }

    profiles::hyperledger::fabric::pull { 'fabric_images':
        images => [
            'hyperledger/fabric-peer',
            'hyperledger/fabric-orderer',
            'hyperledger/fabric-ccenv',
            'hyperledger/fabric-javaenv',
            'hyperledger/fabric-tools',
        ],
        version => $version,
    }

    profiles::hyperledger::fabric::pull { 'third_party_images':
        images => [
            'hyperledger/fabric-couchdb',
            'hyperledger/fabric-kafka',
            'hyperledger/fabric-zookeeper',
        ],
        version => $third_party_version,
    }

    profiles::hyperledger::fabric::pull { 'ca_images':
        images  => [ "hyperledger/fabric-ca" ],
        version => $ca_version,
    }
}
