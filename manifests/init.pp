class ss_logstash (
  $graylog_server   = undef,
  $ls_nice          = 19,
  $ls_opts          = undef,
  $ls_heap_size     = undef,
  $port             = 12201,
  $s3_bucket_region = undef,
  $s3_bucket_name   = undef,
  $s3_time_file     = 60,
  $s3_size_file     = 0,
) {
  class { 'ss_logstash::install': }
}
