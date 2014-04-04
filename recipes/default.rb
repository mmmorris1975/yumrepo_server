#
# Cookbook Name:: yumrepo_server
# Recipe:: default
#
# Copyright 2014, Pearson
#
# All rights reserved - Do Not Redistribute
#

package 'createrepo'

directory node['yum']['server']['repo_base_dir'] do
  action :create
  recursive true
end

# Going to use Apache web server, vs a lighter-weight HTTP
# server, since it's the only option available without
# needing to install the EPEL yum repo
include_recipe 'apache2'
include_recipe 'apache2::logrotate' if node['apache']['include_logrotate']

web_app 'yum-server' do
  server_name node['hostname']
  server_aliases node['fqdn']
  docroot node['yum']['server']['repo_base_dir']
  rewrite 'Off'
end
