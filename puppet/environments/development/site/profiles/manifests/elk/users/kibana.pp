# Creates kibana user and group with fixed uid and gid.
#
# @param uid
#   user id
#
# @param gid
#   group id

class profiles::elk::users::kibana(
    Integer $uid = undef,
    Integer $gid = undef,
) {

    group { 'kibana':
        ensure => present,
        gid    => $gid,
    }

    user { 'kibana':
        ensure     => present,
        comment    => 'Kibana service user',
        gid        => 'kibana',
        home       => '/home/kibana',
        shell      => '/sbin/nologin',
        uid        => $uid,
        require    => Group['kibana'],
    }
}
