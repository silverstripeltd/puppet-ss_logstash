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
  $s3_options = merge($default_s3_options, $ss_logstash::s3_output_options)

  # input pipeline
  logstash::configfile { 'inputs':
    source => 'puppet:///modules/ss_logstash/inputs.conf',
    path   => "${logstash::config_dir}/conf.d/inputs.conf"
  }

  # graylog pipeline
  if $graylog_outputs {
    $graylog_outputs.each | String $name, Hash $config | {
      if !has_key($config, 'type') {
        err("Graylog output '${name}' does not have required 'type' key defined.")
      }
    }

    logstash::configfile { 'graylog':
      content => template('ss_logstash/graylog.conf.erb'),
      path   => "${logstash::config_dir}/conf.d/graylog.conf"
    }
  }

  # S3 pipeline
  if $ss_logstash::s3_output_options and !empty($ss_logstash::s3_output_options) {
    logstash::configfile { 's3':
      content => template('ss_logstash/s3.conf.erb'),
      path   => "${logstash::config_dir}/conf.d/s3.conf"
    }
  }
}
