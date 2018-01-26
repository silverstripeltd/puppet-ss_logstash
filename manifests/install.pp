class ss_logstash::install inherits ss_logstash {

    file { "/etc/logstash/":
        ensure => 'directory',
    }->
    file { "/etc/logstash/conf.d/":
        ensure => 'directory',
    }->
    apt::source { 'logstash':
        comment  => 'This is the logstash Debian stable mirror',
        location => 'https://artifacts.elastic.co/packages/6.x/apt',
        release  => 'stable',
        repos    => 'main',
        key      => {
            'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
            'server' => 'pgp.mit.edu',
        },
        include  => {
            'src' => false,
            'deb' => true,
        },
    }->
    package {
        'logstash':
            ensure => 'installed',
            require => [
                Class['apt::update'],
                Class['java'],
            ],
    }->
    service { 'logstash':
        enable => true,
        ensure => running,
    }->
    exec { 'install_lumberjack':
        command => '/usr/share/logstash/bin/logstash-plugin install logstash-input-lumberjack',
    }->
    exec { 'install_gelf_input':
        command => '/usr/share/logstash/bin/logstash-plugin install logstash-input-gelf',
    }->
    exec { 'install_gelf_output':
        command => '/usr/share/logstash/bin/logstash-plugin install logstash-output-gelf',
    }

    file { "001-lumberjack.conf":
        ensure => present,
        path => "/etc/logstash/conf.d/001-lumberjack.conf",
        owner => "root",
        group => "root",
        mode => "0755",
        content => template("ss_logstash/001-lumberjack.erb"),
        require => File['/etc/logstash/conf.d'],
    }

    file { "010-syslog.conf":
        ensure => present,
        path => "/etc/logstash/conf.d/010-syslog.conf",
        owner => "root",
        group => "root",
        mode => "0755",
        content => template("ss_logstash/010-syslog.erb"),
        require => File['/etc/logstash/conf.d'],
    }

    file { "020-gelf.conf":
        ensure => present,
        path => "/etc/logstash/conf.d/020-gelf.conf",
        owner => "root",
        group => "root",
        mode => "0755",
        content => template("ss_logstash/020-gelf.erb"),
        require => File['/etc/logstash/conf.d'],
    }
}
