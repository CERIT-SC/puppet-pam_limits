define pam_limits (
  $domain,
  $type,
  $item,
  $value,
  $ensure   = present,
  $filename = '/etc/security/limits.conf'
) {
  validate_string($domain, $type, $item, $value)
  validate_absolute_path($filename)

  $comment = "Puppet managed limit (${domain}/${type}/${item}):"
  $path_list = "domain[.='${domain}' and type='${type}' and item='${item}']"
  $path_item = "domain[.='${domain}' and type='${type}' and item='${item}' and value='${value}']"

  Augeas {
    lens    => 'Limits.lns',
    incl    => $filename,
    context => "/files${filename}",
  }

  case $ensure {
    present: {
      augeas { $name:
        onlyif  => "match ${path_item} size < 1",
        changes => [
          "rm ${path_list}",
          "set domain[last()+1] ${domain}",
          "set domain[last()]/type ${type}",
          "set domain[last()]/item ${item}",
          "set domain[last()]/value ${value}",
        ];
      }

      augeas { "${name}-comment":
        require => Augeas[$name],
        onlyif  => "match #comment[. = '${comment}'] size == 0",
        changes => [
          "ins #comment before ${path_list}",
          "set #comment[.=''] '${comment}'"
        ],
      }
    }

    absent: {
      augeas { $name:
        onlyif  => "match ${path_list} size > 0",
        changes => "rm ${path_list}";
      }

      augeas { "${name}-comment":
        onlyif  => "match #comment[. = '${comment}'] size > 0",
        changes => "rm #comment[. = '${comment}']";
      }
    }

    default: {
      fail("Unsupported ensure state: ${ensure}")
    }
  }
}
