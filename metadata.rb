name 'yumrepo_server'
maintainer 'Michael Morris'
maintainer_email 'michael.m.morris@gmail.com'
license '3-clause BSD'
description 'Installs/Configures Yum repository server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.4'

%w(redhat centos).each do |p|
  supports p
end

depends 'apache2'
depends 'logrotate'
