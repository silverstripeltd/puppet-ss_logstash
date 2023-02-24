# This class extends the puppet-logstash module for custom installation of Logstash
#
# @param [Hash] startup_options
#   A collection of settings to be defined in `startup.options`.
#
#   See: https://www.elastic.co/guide/en/logstash/current/config-setting-files.html
#
# @param [Array] jvm_options
#   A collection of settings to be defined in `jvm.options`.
#
# @param [Hash] graylog_outputs
#   A collection of graylog outputs to be consumed in `graylog.conf`.
#
# @param [Hash] s3_output_options
#   A collection of s3 output options to be consumed in `s3.conf`.
#
#   See: https://www.elastic.co/guide/en/logstash/current/plugins-outputs-s3.html
#
# @example Install Logstash, ensure the service is running and enabled (no ouputs).
#   include ss_logstash
#
# @example Configure Logstash startup options.
#   class { 'ss_logstash':
#     startup_options => {
#       'LS_USER' => 'root',
#     }
#   }
#
# @example Set JVM memory options.
#   class { 'ss_logstash':
#     jvm_options => [
#       '-Xms1g',
#       '-Xmx1g',
#     ]
#   }
#
# @example Configure multiple Graylog outputs.
#   class { 'logstash':
#     graylog_outputs => {
#       gelf => {
#         host     => "domain-endpoint.com",
#         port     => 12201,
#         protocol => "TCP"
#       },
#       opensearch => {
#         hosts       => "https://domain-endpoint.com:443"
#         user        => "my-username"
#         password    => "my-password"
#         index       => "logstash-logs-%{+YYYY.MM.dd}"
#         ecs_compatibility => disabled
#         ssl_certificate_verification => false
#       }
#     }
#   }
#
# @example Configure S3 output options.
#   class { 'logstash':
#     s3_output_options => {
#       'bucket ' => 'your_bucket',
#       'region' => 'ap-southeast-2'
#     }
#   }
#
# @author https://github.com/silverstripeltd/puppet-ss_logstash/graphs/contributors
#
class ss_logstash (
  $startup_options    = undef,
  $jvm_options        = undef,
  $graylog_outputs    = undef,
  $s3_output_options  = undef,
) {
  class { 'logstash':
    manage_repo => false,
    startup_options => $startup_options,
    jvm_options => $jvm_options,
  }

  contain ss_logstash::install
  contain ss_logstash::config
}
