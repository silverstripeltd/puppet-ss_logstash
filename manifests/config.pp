# This is a private class and should not be called directly
class ss_logstash::config {

  $default_s3_options = {
    'encoding'                => 'gzip',
    'server_side_encryption'  => true,
    'time_file'               => 60,
    'size_file'               => 0,
    'codec'                   => 'line',
    'canned_acl'              => 'private',
    'rotation_strategy'       => 'time',
    'prefix'                  => 'year=%{+YYYY}/month=%{+MM}/day=%{+dd}'
  }

  $graylog_outputs = $ss_logstash::graylog_outputs
  $s3_options = merge($default_s3_options, $ss_logstash::s3_options)

  # input pipeline
  logstash::configfile { 'inputs':
    content => template('ss_logstash/inputs.conf.erb'),
  }

  # graylog pipeline
  if $graylog_outputs {
    logstash::configfile { 'graylog':
      content => template('ss_logstash/graylog.conf.erb'),
    }
  }

  # S3 pipeline
  if $ss_logstash::s3_options {
    logstash::configfile { 's3':
      content => template('ss_logstash/s3.conf.erb'),
    }
  }
}
