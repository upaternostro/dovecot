class dovecot::static (
  $uid = 'vmail',
  $gid = 'vmail',
  $home = '/srv/vmail/%d/%u/',
  $allow_all_users = undef,
) {
  file { "/etc/dovecot/conf.d/auth-static.conf.ext":
    ensure  => file,
    content => template('dovecot/auth-static.conf.ext'),
    mode    => '0600',
    owner   => root,
    before  => Exec['dovecot'],
  }

  dovecot::config::dovecotcfmulti { 'staticauth':
    config_file => 'conf.d/10-auth.conf',
    changes     => [
      "rm  include[ . = 'auth-static.conf.ext']",
      "set include[last()+1] 'auth-static.conf.ext'",
    ],
    require     => File["/etc/dovecot/conf.d/auth-static.conf.ext"]
  }
}
