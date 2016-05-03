default['yum']['server']['repo_base_dir'] = '/var/lib/yum-repo'
default['yum']['server']['http_aliases'] = []
default['yum']['server']['http_port'] = '*:80'

default['apache']['include_logrotate'] = true

normal['apache']['service_name'] = value_for_platform_family(
  %w(rhel fedora) => 'httpd',
  'default' => node['apache']['package']
)
