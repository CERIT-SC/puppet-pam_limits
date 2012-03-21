pam_limits::limit {
	'soft-core':
		ensure	=> present,
		domain	=> '*',
		type	=> 'soft',
		item	=> 'core',
		value	=> 0;
	'hard-core':
		ensure	=> absent,
		domain	=> '*',
		type	=> 'hard',
		item	=> 'core',
		value	=> 0;
}
