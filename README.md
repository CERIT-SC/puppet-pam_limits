# Puppet pam\_limits module

This module manages pam\_limits configuration files (only).

### Overview

This is the Puppet pam\_limits module. It can be used to manage
particular limits in single /etc/security/limits.conf or in 
separate files included from /etc/security/limits.d (if "context"
was specified). The second feature is only supported on new
systems where Augeas can manage these files.

This module is a mix of other Puppet modules and Wiki, esp.:

* http://projects.puppetlabs.com/projects/1/wiki/puppet_augeas#/etc/security/limits.conf
* https://github.com/kupson/puppet-pam_limits/blob/master/manifests/init.pp

to meet these requirements (which other modules didn't):

* modify conf. files with Augeas only
* prepend each Puppet managed limit with comment
* support both limits.conf and includes from limits.d/
* don't install anything

### Requirements

Module has been tested on:

* Puppet 2.7
* Debian 6.0

# Quick Start

Configure limit

```puppet
pam_limits { name:
  ensure   => present or absent,
  filename => configuration file,
  domain   => user or group name, wildcard, 
  type     => soft or hard or -,
  item     => limit name,
  value    => limit value;
}
```

Example: set max number of processes for users in group 'student'

```puppet
pam_limits { 'nproc-student':
  ensure  => present,
  domain  => '@student',
  type    => 'hard',
  item    => 'nproc',
  value   => '20';
}
```

***

CERIT Scientific Cloud, <support@cerit-sc.cz>
