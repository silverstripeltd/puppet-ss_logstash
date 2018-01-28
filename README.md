# puppet-ss_logstash

## Configuration

In your `Puppetfile` add:

```
mod 'silverstripe-ss_logstash',
  :git => "https://github.com/silverstripeltd/puppet-ss_logstash.git"
```

Then in your manifest you will need:

```
class { 'ss_logstash':
		graylog_server => "my.graylog.server",
	}
```

This module is setup to create a logstash installation that uses TCP to send the messages to a Graylog server, usually UDP is used but this is not compatible with AWS' ELB which only supports TCP (at the time of writing).