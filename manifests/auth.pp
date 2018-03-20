# 10-auth.conf
class dovecot::auth (
  $disable_plaintext_auth = 'no',
  $auth_mechanisms        = 'plain login',
  $auth_username_format   = '%Ln',
  $auth_default_realm     = undef,
) {
  include dovecot

  $changes = [
    "set disable_plaintext_auth '${disable_plaintext_auth}'",
    "set auth_mechanisms '${auth_mechanisms}'",
    "set auth_username_format '${auth_username_format}'",
  ]

  if $auth_default_realm != undef {
    $changes = concat($changes, "set auth_default_realm '${auth_default_realm}'")
  } else {
    $changes = concat($changes, "rm auth_default_realm")
  }

  dovecot::config::dovecotcfmulti { 'auth':
    config_file => 'conf.d/10-auth.conf',
    changes     => $changes,
  }
}
