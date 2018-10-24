# Creates elasticsearch user and group with fixed uid and gid.
#
# @param uid
#   user id
#
# @param gid
#   group id

class profiles::elk::users::elasticsearch(
    Integer $uid = undef,
    Integer $gid = undef,
) {

    group { 'elasticsearch':
        ensure => present,
        gid    => $gid,
    }

    user { 'elasticsearch':
        ensure     => present,
        comment    => 'Elasticsearch service user',
        gid        => 'elasticsearch',
        home       => '/home/elasticsearch',
        shell      => '/sbin/nologin',
        uid        => $uid,
        require    => Group['elasticsearch'],
    }
}
