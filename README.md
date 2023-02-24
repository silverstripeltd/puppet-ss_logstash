# ss_logstash

A Puppet module for managing and configuring [Logstash](https://www.elastic.co/logstash/).

This modules extends the [puppet-logstash](https://forge.puppetlabs.com/modules/puppet/logstash/) module for custom installation of Logstash
and is intended to be used with Silverstripe's Hiera config model.

## Requirements

* The [stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib) module.
* Requires Java. The [puppetlabs/java](https://forge.puppetlabs.com/modules/puppetlabs/java) module is recommended
  for installing Java.

Optional:
* The [elastic_stack](https://forge.puppetlabs.com/elastic/elastic_stack) module
  when using automatic repository management.
* The [apt](https://forge.puppetlabs.com/puppetlabs/apt) (>= 2.0.0) module when
  using repo management.

## Installation

In your `Puppetfile` add:

```
mod 'silverstripe-ss_logstash',
  :git => "https://github.com/silverstripeltd/puppet-ss_logstash.git"
```

And update your installed Puppet modules using `librarian-puppet`

## Quick Start

This minimum viable configuration ensures that Logstash is installed, enabled, running and sending logs to Graylog:

``` yaml
base_includes:
 - ss_logstash

ss_logstash::graylog_outputs:
	graylog:
		type: gelf
		host: 'my.graylog.server'
		port: 12201
		protocol: 'TCP'
```

## Graylog Output configuration

Graylog outputs can be configured to support any outputs with Logstash through the `graylog_outputs` parameter. By default 
no outputs are configured so this will need to be done manually.

``` yaml
ss_logstash::graylog_outputs:
	graylog:
		type: gelf
		host: 'my.graylog.server'
		port: 12201
		protocol: 'TCP'
```

You can also configure alternative outputs such as Elasticsearch or Opensearch if the plugin is installed.

E.g. This example shows how to configure Opensearch output for Graylog using HTTP basic authentication.
See: [https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-logstash.html](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-logstash.html)

``` yaml
ss_logstash::graylog_outputs:
	opensearch:
		type: opensearch
		hosts: 'https://domain-endpoint:443'
		user: 'my-username'
		password: 'my-password'
		index: 'logstash-logs-%{+YYYY.MM.dd}'
		ecs_compatibility: "disabled"
		ssl_certificate_verification: false
```

## S3 Output

To enable storage of log files in S3 buckets for security, you will need to configure the S3 bucket endpoints

``` yaml
ss_logstash::s3_output_options:
	bucket: 'your_bucket'
	region: 'ap-southeast-2' 
```

This module sets a handful of S3 Output Options by default, however these can be overridden by providing them as key/value pairs as above.
See: [https://www.elastic.co/guide/en/logstash/current/plugins-outputs-s3.html](https://www.elastic.co/guide/en/logstash/current/plugins-outputs-s3.html)

## Plugin management

### Installing by name (from RubyGems.org)

``` yaml
ss_logstash::plugins:
 - logstash-output-opensearch
```
