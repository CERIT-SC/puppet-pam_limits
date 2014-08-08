pam_limits { 'soft-core':
  ensure => present,
  domain => '*',
  type   => 'soft',
  item   => 'core',
  value  => 0,
}

pam_limits { 'hard-core':
  ensure => absent,
  domain => '*',
  type   => 'hard',
  item   => 'core',
  value  => 0,
}
