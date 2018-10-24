# Installs Elasticsearch package.
#
# @param data_dir
#   data directory

class profiles::elk::elasticsearch::install(
      String $data_dir = undef,
) {
      class { 'elasticsearch':
            manage_repo       => false,
            purge_configdir   => false,
            restart_on_change => true,
            datadir           => $data_dir,
            #security_plugin   => 'x-pack', # Requires commercial license
            # config => {
            #       'xpack.license.self_generated.type' => 'basic', # Standard basic license (free)
            #       'xpack.security.enabled' => false,
            # }, 
      }
}
