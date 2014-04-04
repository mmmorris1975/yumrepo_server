actions :create, :delete, :update
default_action :create

# Directory to create under node['yum']['server']['repo_base_dir']
attribute :dir, kind_of: String, name_attribute: true, required: true

# Options to pass to createrepo/modifyrepo cmd
attribute :options, kind_of: String

# Array of RPM package file names to retrieve from :remote_source,
# or to pass to createrepo cmd.
# Must be supplied with :remote_source option, otherwise optional,
# and defaults to all pkgs under :dir
attribute :packages, kind_of: Array

# URL of source to retrieve pkgs from
# (protocol must be supported by remote_file resource)
attribute :remote_source, String
