require 'spec_helper'

platforms = {
  redhat: %w(6.3 6.4 6.5),
  centos: %w(6.3 6.4 6.5),
  fedora: %w(18 19 20)
}

platforms.each_pair do |p, v|
  Array(v).each do |ver|
    describe 'yumrepo_server::default' do
      # Use an explicit subject
      let(:chef_run) do
        ChefSpec::Runner.new(platform: p.to_s, version: ver, log_level: :warn) do |node|
          Chef::Log.debug(format('#### FILE: %s  PLATFORM: %s  VERSION: %s ####', ::File.basename(__FILE__), p, ver))

          node.automatic['hostname'] = 'testhost'
          node.automatic['fqdn'] = 'testhost.yumserver.local'
          node.automatic['ipaddress'] = '55.55.55.55'

          node.override['yum']['server']['http_aliases'] = ['server-alias']
        end.converge(described_recipe)
      end

      before do
        # Needed for apache2 2.0+ cookbook
        stub_command('/usr/sbin/httpd -t').and_return(0)
      end

      it 'creates the root repository directory' do
        expect(chef_run).to create_directory '/var/lib/yum-repo'
      end

      it 'installs the createrepo package' do
        expect(chef_run).to install_package 'createrepo'
      end

      it 'installs apache' do
        expect(chef_run).to include_recipe 'apache2'
        expect(chef_run).to install_package 'httpd'
      end

      it 'installs and configures logrotate' do
        expect(chef_run).to include_recipe 'apache2::logrotate'
        expect(chef_run).to include_recipe 'logrotate'
        expect(chef_run).to install_package 'logrotate'

        file = '/etc/logrotate.d/httpd'
        expect(chef_run).to create_template file
        expect(chef_run).to render_file file
      end

      it 'configures the yum repo in apache' do
        file = '/etc/httpd/sites-available/yum-server.conf'

        expect(chef_run).to create_template file

        expect(chef_run).to render_file(file).with_content(/<VirtualHost\s+\*:80>/)
        expect(chef_run).to render_file(file).with_content(/ServerName\s+testhost/)
        expect(chef_run).to render_file(file).with_content(/ServerAlias\s+testhost.yumserver.local\s+55.55.55.55/)
        expect(chef_run).to render_file(file).with_content(/ServerAlias\s+.*\s+server-alias/)
        expect(chef_run).to render_file(file).with_content %r{DocumentRoot\s+/var/lib/yum-repo$}
        expect(chef_run).to render_file(file).with_content %r{<Directory\s+/var/lib/yum-repo>$}
        expect(chef_run).to render_file(file).with_content %r{ErrorLog\s+/var/log/httpd/yum-server-error.log$}
        expect(chef_run).to render_file(file).with_content %r{CustomLog\s+/var/log/httpd/yum-server-access.log combined$}
        expect(chef_run).to render_file(file).with_content(/RewriteEngine\s+Off$/)
        expect(chef_run).to render_file(file).with_content %r{RewriteLog\s+/var/log/httpd/yum-server-rewrite.log$}
      end

      it 'configures the yum repo in apache on a custom port' do
        chef_run.node.set['yum']['server']['http_port'] = 9090
        chef_run.converge(described_recipe)

        file = '/etc/httpd/sites-available/yum-server.conf'

        expect(chef_run).to create_template file

        expect(chef_run).to render_file(file).with_content(/<VirtualHost\s+\*:9090>/)
        expect(chef_run).to render_file(file).with_content(/ServerName\s+testhost/)
        expect(chef_run).to render_file(file).with_content(/ServerAlias\s+testhost.yumserver.local\s+55.55.55.55/)
        expect(chef_run).to render_file(file).with_content(/ServerAlias\s+.*\s+server-alias/)
        expect(chef_run).to render_file(file).with_content %r{DocumentRoot\s+/var/lib/yum-repo$}
        expect(chef_run).to render_file(file).with_content %r{<Directory\s+/var/lib/yum-repo>$}
        expect(chef_run).to render_file(file).with_content %r{ErrorLog\s+/var/log/httpd/yum-server-error.log$}
        expect(chef_run).to render_file(file).with_content %r{CustomLog\s+/var/log/httpd/yum-server-access.log combined$}
        expect(chef_run).to render_file(file).with_content(/RewriteEngine\s+Off$/)
        expect(chef_run).to render_file(file).with_content %r{RewriteLog\s+/var/log/httpd/yum-server-rewrite.log$}
      end
    end
  end
end
