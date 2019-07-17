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

    file { "001-lumberjack.conf":
        ensure => present,
        path => "/etc/logstash/conf.d/001-lumberjack.conf",
        owner => "root",
        group => "root",
        mode => "0644",
        content => template("ss_logstash/001-lumberjack.erb"),
        require => File['/etc/logstash/conf.d/'],
        notify => Service['logstash'],
    }

    file { "002-beats.conf":
        ensure => present,
        path => "/etc/logstash/conf.d/002-beats.conf",
        owner => "root",
        group => "root",
        mode => "0644",
        content => template("ss_logstash/002-beats.erb"),
        require => File['/etc/logstash/conf.d/'],
        notify => Service['logstash'],
    }

    file { "010-syslog.conf":
        ensure => present,
        path => "/etc/logstash/conf.d/010-syslog.conf",
        owner => "root",
        group => "root",
        mode => "0644",
        content => template("ss_logstash/010-syslog.erb"),
        require => File['/etc/logstash/conf.d/'],
        notify => Service['logstash'],
    }

    file { "020-gelf.conf":
        ensure => present,
        path => "/etc/logstash/conf.d/020-gelf.conf",
        owner => "root",
        group => "root",
        mode => "0644",
        content => template("ss_logstash/020-gelf.erb"),
        require => File['/etc/logstash/conf.d/'],
        notify => Service['logstash'],
    }


}
