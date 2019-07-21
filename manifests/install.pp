class ss_logstash::install inherits ss_logstash {

    file { "/etc/logstash/":
        ensure => 'directory',
        owner => "root",
        group => "root",
        mode => "0755",
    }->
    file { "/etc/logstash/conf.d/":
        ensure => 'directory',
        owner => "root",
        group => "root",
        mode => "0755",
    }->
    apt::source { 'logstash':
        comment  => 'This is the logstash Debian stable mirror',
        location => 'https://artifacts.elastic.co/packages/7.x/apt',
        release  => 'stable',
        repos    => 'main',
        key      => {
            'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
            'server' => 'keyserver.ubuntu.com',
        },
        include  => {
            'src' => false,
            'deb' => true,
        },
    }->
    # we need to have this file in-place before installing logstash since the info in this file is used to create the systemd unit
    file { "startup.options":
      ensure => present,
      path => "/etc/logstash/startup.options",
      owner => "root",
      group => "root",
      mode => "0644",
      content => template("ss_logstash/startup_options.erb"),
    }->
    package { 'logstash':
        ensure => 'installed',
        require => Class['apt::update'],
    }->
    service { 'logstash':
        enable => true,
        ensure => running,
    }

    file { "jvm.options":
      ensure => present,
      path => "/etc/logstash/jvm.options",
      owner => "root",
      group => "root",
      mode => "0644",
      content => template("ss_logstash/jvm_options.erb"),
      notify => Service["logstash"],
    }

    exec { 'install_lumberjack':
        command => '/usr/share/logstash/bin/logstash-plugin install logstash-input-lumberjack',
        timeout => 1800,
        require => Package['logstash'],
        notify => Service["logstash"],
        unless => "/bin/grep 'logstash-input-lumberjack' /usr/share/logstash/Gemfile",
    }

    exec { 'install_beats':
        command => '/usr/share/logstash/bin/logstash-plugin install logstash-input-beats',
        timeout => 1800,
        require => Package['logstash'],
        notify => Service["logstash"],
        unless => "/bin/grep 'logstash-input-beats' /usr/share/logstash/Gemfile",
    }

    exec { 'install_gelf_input':
        command => '/usr/share/logstash/bin/logstash-plugin install logstash-input-gelf',
        timeout => 1800,
        require => Package['logstash'],
        notify => Service["logstash"],
        unless => "/bin/grep 'logstash-input-gelf' /usr/share/logstash/Gemfile",
    }

    exec { 'install_gelf_output':
        command => '/usr/share/logstash/bin/logstash-plugin install logstash-output-gelf',
        timeout => 1800,
        require => Package['logstash'],
        notify => Service["logstash"],
        unless => "/bin/grep 'logstash-output-gelf' /usr/share/logstash/Gemfile",
    }

    # pipeline config starts here

  file { "/etc/logstash/pipelines.yml":
    ensure => present,
    owner => "root",
    group => "root",
    mode => "0644",
    content => template("ss_logstash/pipelines.yml.erb"),
    require => File['/etc/logstash/'],
    notify => Service['logstash'],
  }

  # input pipeline
  file { "/etc/logstash/conf.d/inputs.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => "0644",
    content => template("ss_logstash/inputs.erb"),
    require => File['/etc/logstash/conf.d/'],
    notify => Service['logstash'],
  }

  file { "/etc/logstash/conf.d/graylog.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => "0644",
    content => template("ss_logstash/graylog.erb"),
    require => File['/etc/logstash/conf.d/'],
    notify => Service['logstash'],
  }

  # S3 pipeline output

}
