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
- [mmmorris1975] - Changes required to support Centos 7 to install yum repo. (should still be Chef 11 compliant!)

0.2.1
-----
- [mmmorris1975] - Address issue #3, removed invalid Apache 2.4 directives 'Order' and 'RewriteLog'
- [mmmorris1975] - Added additional serverspec test to run `httpd -t` to test Apache syntax

0.2.2
-----
- [mmmorris1975] - Change locking for apache2 cookbook to ~> 3.1.0 to avoid breaking changes in 3.2.x

0.3.0
-----
- [mmmorris1975] - Updated cookbook to use apache2 3.2.x cookbook and the attribute changes it requires
