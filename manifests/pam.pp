class dovecot::pam (
  $service_name = undef,
  $session = undef,
  $setcred = undef,
  $max_requests = undef,
  $failure_show_msg = undef,
  $cache_key = undef,
  $allow_nets = [],
) {
  file { "/etc/dovecot/conf.d/auth-pam.conf.ext":
    ensure  => file,
    content => template('dovecot/auth-pam.conf.ext'),
    mode    => '0600',
    owner   => root,
    before  => Exec['dovecot'],
  }

  dovecot::config::dovecotcfmulti { 'pamauth':
    config_file => 'conf.d/10-auth.conf',
    changes     => [
      "set include 'auth-pam.conf.ext'",
      "rm  include[ . = 'auth-system.conf.ext']",
    ],
    require     => File["/etc/dovecot/conf.d/auth-pam.conf.ext"]
  }
}
