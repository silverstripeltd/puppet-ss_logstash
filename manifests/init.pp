class ss_logstash (
	$graylog_server = undef,
	$ls_nice = 19,
	$ls_opts = undef,
	$ls_heap_size = undef,
	$kill_on_stop_timeout = undef
	$port = 12201,
	) {
    class { 'ss_logstash::install': }
}