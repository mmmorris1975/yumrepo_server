require 'tempfile'

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  cmd  = 'createrepo ' + shell_sanitize(@new_resource.options)
  dir  = resolve_full_path(@new_resource.dir)
  pkgs = @new_resource.packages
  src  = @new_resource.remote_source

  directory dir do
    action :create
    recursive true
  end

  begin
    converge_by 'Creating repo at #{dir}' do
      unless pkgs.nil? || pkgs.empty
        cmd = cmd << '-i ' + create_pkg_file(pkgs)
        download_pkgs(src, dir, pkgs) if src
      end

      Chef::Log.debug "Creating repo #{dir} with command #{cmd}"
      execute 'create yum repo' do
        action :run
        cwd dir
        command cmd
      end
    end
  ensure
    file pkg_file do
      action :delete
    end
  end
end

action :delete do
  dir = resolve_full_path(@new_resource.dir)

  if ::Dir.exist?(::File.join(dir, 'repodata'))
    converge_by 'Delete repo dir #{dir}' do
      Chef::Log.debug "Deleting repo at #{dir}"

      directory dir do
        action :delete
        recursive true
      end
    end
  else
    Chef::Log.warn "#{dir} does not appear to be a repository directory, will not delete"
  end
end

action :update do
  dir  = resolve_full_path(@new_resource.dir)
  opts = shell_sanitize(@new_resource.options)

  if ::Dir.exist?(::File.join(dir, 'repodata'))
    converge_by 'Updating repo dir #{dir}' do
      cmd = "createrepo --update #{opts}"
      Chef::Log.debug "Updating repo at #{dir} with command #{cmd}"

      execute 'update yum repo' do
        action :run
        cwd dir
        command cmd
      end
    end
  else
    Chef::Log.warn "#{dir} does not appear to be a repository directory, will not update"
  end
end

def download_pkgs(src, dir, pkgs)
  pkgs.each do |p|
    url = src << "/#{p}"
    dst = ::File.join(dir, p)
    Chef::Log.debug "Downloading #{url} to #{dst}"

    remote_file dst do
      action :create
      backup false
      source url
    end
  end
end

def create_pkg_file(pkg_ary)
  unless pkg_ary.nil? || pkg_ary.empty?
    f = Tempfile.new('yum_pkg_list')

    begin
      f.write(pkg_ary.join("\n"))
    ensure
      f.close
    end

    f.path
  end
end

def resolve_full_path(res_dir)
  base_dir = node['yum']['repo_base_dir']

  dir = ::File.join(base_dir, res_dir)
  dir = res_dir if res_dir.start_with?(base_dir)

  dir
end

def shell_sanitize(str)
  str.strip.shellescape
end
