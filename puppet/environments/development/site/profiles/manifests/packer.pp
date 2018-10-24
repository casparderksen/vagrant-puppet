# Installs Packer.

class profiles::packer {
    notice("applying profiles::packer")

    $version = '1.2.2'
    $archive = "packer_${version}_linux_amd64.zip"

    archive { "/tmp/${archive}":
        ensure          => present,
        extract         => true,
        extract_path    => '/usr/local/bin',
        source          => "puppet:///files/tools/${archive}",
        checksum_verify => false,
        cleanup         => true,
    }
}
