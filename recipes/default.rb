#
# Cookbook Name:: yumrepo_server
# Recipe:: default
#
# Copyright 2014, Michael Morris
# LICENSE: 3-clause BSD
#

package 'createrepo'

directory node['yum']['server']['repo_base_dir'] do
  action :create
  recursive true
end

# Going to use Apache web server, vs a lighter-weight HTTP
# server, since it's the only option available without
# needing to install the EPEL yum repo
#
# Needs lots of changes to make apache work in Fedora 18/19/20 (apache 2.4)
# Not going to bother testing older Fedora's since the project moves so fast,
# anything older is obsolete/unsupported
node.default['apache']['listen_ports'] << node['yum']['server']['http_port']
include_recipe 'apache2'
include_recipe 'apache2::logrotate' if node['apache']['include_logrotate']

web_app 'yum-server' do
  server_name node['hostname']
  server_port node['yum']['server']['http_port']
  server_aliases [node['fqdn'], node['ipaddress']] + node['yum']['server']['http_aliases']
  docroot node['yum']['server']['repo_base_dir']
  directory_options 'Indexes MultiViews FollowSymlinks'
  rewrite 'Off'
end
