define pam_limits::limit (
	$ensure		= present,
	$context	= undef,
	$domain,
	$type,
	$item,
	$value,
) {
	# limits with user supplied "context" are stored into
	# separate files in limits.d/, otherwise global config
	# is edited
	$aug_prefix = '/files/etc/security/limits'
	$comment	= "Puppet managed limit (${domain}/${type}/${item}):"
	$path_list	= "domain[.='${domain}' and type='${type}' and item='${item}']"
	$path_exact	= "domain[.='${domain}' and type='${type}' and item='${item}' and value='${value}']"

	case $context {
		undef: {
			$aug_context = "${aug_prefix}.conf"
			warning("Context not specified, using ${aug_context}")
		}

		default: {
			$aug_context = "${aug_prefix}.d/${context}.conf"
		}
	}

	Augeas {
		context	=> $aug_context
	}

	case $ensure {
		present: {
			augeas {
				"${name}":
					onlyif	=> "match ${path_exact} size < 1",
					changes	=> [ 
						"rm  ${path_list}",
						"set domain[last()+1] ${domain}",
						"set domain[last()]/type ${type}",
						"set domain[last()]/item ${item}",
						"set domain[last()]/value ${value}",
					];
				"${name}-comment":
					require	=> Augeas["${name}"],
					onlyif	=> "match #comment[. = '${comment}'] size == 0",
					changes	=> [
						"ins #comment before domain[last()]",
						"set #comment[last()] '${comment}'"
					],
			}
		}

		absent: {
			augeas {
				"${name}":
					onlyif	=> "match ${path_list} size > 0",
					changes	=> "rm ${path_list}";
				"${name}-comment":
					onlyif	=> "match #comment[. = '${comment}'] size > 0",
					changes	=> "rm #comment[. = '${comment}']";
            }
		}

		default: {
			fail("Unsupported ensure state '${ensure}'")
		}
	}
}
