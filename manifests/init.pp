class ss_logstash (
    $graylog_server = ''
    ) {
    class { 'ss_logstash::install': }
}