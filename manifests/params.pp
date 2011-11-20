#used in multiple locations, including the global scoped defines..

case $operatingsystem {
    debian: { $apache2_service_name = "apache2"
              $apache2_serverconfig = "/etc/apache2/apache2.conf"
              $apache2_confdir = "/etc/apache2"
              $vhost_enabled_dir = "/etc/apache2/sites-enabled"
              $vhost_available_dir = "/etc/apache2/sites-available"
              $cronolog = "/usr/bin/cronolog"
            }
    Ubuntu: { $apache2_service_name = "apache2"
              $apache2_serverconfig = "/etc/apache2/apache2.conf"
              $apache2_confdir = "/etc/apache2"
              $vhost_enabled_dir = "/etc/apache2/sites-enabled"
              $vhost_available_dir = "/etc/apache2/sites-available"
              $cronolog = "/usr/bin/cronolog"
            }
    redhat: { $apache2_service_name = "httpd"
               $apache2_serverconfig = "/etc/httpd/conf/httpd.conf"
               $apache2_confdir = "/etc/httpd/conf"
               $vhost_enabled_dir = "/etc/httpd/sites-enabled"
               $vhost_available_dir = "/etc/httpd/sites-available"
               $cronolog = "/usr/sbin/cronolog"
             }
    centos: { $apache2_service_name = "httpd"
               $apache2_serverconfig = "/etc/httpd/conf/httpd.conf"
               $apache2_confdir = "/etc/httpd/conf"
               $vhost_enabled_dir = "/etc/httpd/sites-enabled"
               $vhost_available_dir = "/etc/httpd/sites-available"
               $cronolog = "/usr/sbin/cronolog"
             }
    default: { }
}

