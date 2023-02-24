# This is a private class and should not be called directly
class ss_logstash::install {  
  # Install log4j2 properties file for Java logging
  file { "${logstash::config_dir}/log4j2.properties":
    ensure => present,
    source => 'puppet:///modules/ss_logstash/log4j2.properties',
    notify => Service['logstash'],
  }

  # Install default plugins
  logstash::plugin { 'logstash-input-lumberjack': }
  logstash::plugin { 'logstash-input-beats': }

  # Install custom plugins
  create_resources('logstash::plugin', lookup('ss_logstash::plugins', Hash, undef, {}))
}
