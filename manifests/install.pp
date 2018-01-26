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
    }

    file { "001-lumberjack.conf":
        ensure => present,
        path => "/etc/logstash/conf.d/001-lumberjack.conf",
        owner => "root",
        group => "root",
        mode => "0755",
        content => template("ss_logstash/001-lumberjack.erb"),
    }

    file { "010-syslog.conf":
        ensure => present,
        path => "/etc/logstash/conf.d/010-syslog.conf",
        owner => "root",
        group => "root",
        mode => "0755",
        content => template("ss_logstash/010-syslog.erb"),
    }

    file { "020-gelf.conf":
        ensure => present,
        path => "/etc/logstash/conf.d/020-gelf.conf",
        owner => "root",
        group => "root",
        mode => "0755",
        content => template("ss_logstash/020-gelf.erb"),
    }
}
