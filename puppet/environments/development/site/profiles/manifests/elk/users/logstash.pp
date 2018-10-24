# Creates logstash user and group with fixed uid and gid.
#
# @param uid
#   user id
#
# @param gid
#   group id

class profiles::elk::users::logstash(
    Integer $uid = undef,
    Integer $gid = undef,
) {

    group { 'logstash':
        ensure => present,
        gid    => $gid,
    }

    user { 'logstash':
        ensure     => present,
        comment    => 'Logstash service user',
        gid        => 'logstash',
        home       => '/usr/share/logstash',
        shell      => '/sbin/nologin',
        uid        => $uid,
        require    => Group['logstash'],
    }
}
