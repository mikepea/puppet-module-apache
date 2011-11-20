
class apache {

    File {
        owner => root,
        group => root,
        mode  => 0644,
    }

    Dir {
        owner => root,
        group => root,
        mode  => 2755,
    }

    include apache::service::control

    package { apache2:
        name => $apache2_service_name,
        ensure => $update ? {
            true    => "present",
            false    => "present",
            default => "present",
        },
    }

    service { apache2:
        name => $operatingsystem ? {
            debian  => "apache2",
            Ubuntu  => "apache2",
            default => "httpd",
        },
        ensure => running,
        enable => true,
        pattern => "${apache2_service_name}",
        hasrestart => true,
        hasstatus => true,
        require => Package["apache2"],
    }

    case $operatingsystem {
        Debian: {  include apache::service::debian }
        Ubuntu: {  include apache::service::debian }
        Redhat: {  include apache::service::redhat }
        Centos: {  include apache::service::redhat }
    }

    # CONFIG

    # Base Apache config is left as the OS default but include lines are added to allow the config to be changed

    # This file contains any parameters that you want to override using the apache::override define
    file { "apache_override.conf":
        path   => "/etc/$apache2_service_name/apache_override.conf",
        mode    => 0440,
        notify => Exec["reload-apache2"],
        require => Package["apache2"],
    }

    #templated override for multiline server wide customizations
    file { "apache_templated_override":
        path   => "/etc/$apache2_service_name/apache_templated_override.conf",
        content => template("apache/apache_templated_override.erb"),
        mode    => 0440,
        notify => Exec["reload-apache2"],
        require => Package["apache2"],
    }

    #### Make rhel and debian behave in the same way
    dir { "sites-enabled":
        path   => "/etc/$apache2_service_name/sites-enabled",
        require => Package["apache2"],
    }

    dir { "sites-available":
        path   => "/etc/$apache2_service_name/sites-available",
        require => Package["apache2"],
    }

    ### Remove default installation options
    file { "default_welcome_conf":
        path   => "/etc/$apache2_service_name/conf.d/welcome.conf",
        ensure => absent,
        require => Package["apache2"],
    }

    #This file is templated to allow for namebased virtualhosting and listening on ip:port
    #When ports are updated the service needs restarting
    file { "/etc/${apache2_service_name}/ports.conf":
        ensure => present,
        content => template("apache/ports.conf"),
        mode    => 0444,
        require => Package["apache2"],
        notify => Exec["restart-apache2"],
    }

    dir { "${apache2_confdir}/ssl.prm" : require => Package["apache2"] }
    dir { "${apache2_confdir}/ssl.crl" : require => Package["apache2"] }
    dir { "${apache2_confdir}/ssl.crt" : require => Package["apache2"] }
    dir { "${apache2_confdir}/ssl.key" : require => Package["apache2"] }
    dir { "${apache2_confdir}/ssl.csr" : require => Package["apache2"] }

    cron { all_apache_logs_compress:
        tag => "autoapply",
        command => "/opt/semantico/bin/compress_logs --run -p /var/log/${apache2_service_name}/cronolog/ --prune 250",
        minute => "1",
        hour => "3",
        weekday => "0",
    }

    ###################################################
    #CUSTOMIZATIONS

    # By default add this custom log format
    apache::override { 'LogFormat "%h %l %u %t \"%r\" %>s %b %T \"%{Referer}i\" \"%{User-Agent}i\"" combined_plus_time': }

    realize Package['cronolog']

    #this directory has very strict permissions on RHEL
    dir { "/var/log/apache2":
        mode => 0755,
    }

}
