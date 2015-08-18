yumrepo_server CHANGELOG
=========================

0.1.0
-----
- [mmmorris1975] - Initial release of yumrepo_server

0.1.1
-----
- [mmmorris1975] - Added node['ipaddress'] to the array of server_alias values in the web_app lwrp
- [mmmorris1975] - Added test kitchen, removed Fedora from supported platforms.

0.1.2
-----
- [mmmorris1975] - Added attribute to pass in custom httpd ServerAlias values
- [mmmorris1975] - Updated file headers to include correct copyright/license info

0.1.3
-----
- [mmmorris1975] - Changed bundle process from tar to 'knife cookbook site share'

0.1.4
-----
- [gimler] - Added option to specify http port 

0.1.5
-----
- [mmmorris1975] - Fixed GitHub issue #2, adding conditional guard in 'ensure' block for lwrp :create action

0.2.0
-----
- [mmmorris1975] - Changes required to support Centos 7 to install yum repo.
