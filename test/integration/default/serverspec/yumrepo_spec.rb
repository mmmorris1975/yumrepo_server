require 'spec_helper'

describe package 'createrepo' do
  it { should be_installed }
end

describe package 'httpd' do
  it { should be_installed }
end

describe service 'httpd' do
  it { should be_enabled }
  it { should be_running }
end

describe process 'httpd' do
  it { should be_running }
end

describe command 'httpd -t' do
  its(:exit_status) { should eq 0 }
end

describe port 80 do
  it { should be_listening }
  it { should_not be_listening.with('udp') }
  it { should_not be_listening.with('udp6') }
end

describe file '/var/lib/yum-repo' do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file '/etc/httpd/sites-available/yum-server.conf' do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }

  its(:content) { should match %r{DocumentRoot\s+/var/lib/yum-repo} }
  its(:content) { should match(/RewriteEngine\s+Off/) }
end

describe file '/etc/httpd/sites-enabled/yum-server.conf' do
  it { should be_linked_to '../sites-available/yum-server.conf' }
end
