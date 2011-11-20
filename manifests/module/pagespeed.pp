class apache::module::pagespeed {

    package { "mod-pagespeed-beta":
        ensure => present,
    }

    apache::module { "pagespeed": 
        conf_file => "pagespeed.conf.erb",
        require => Package["mod-pagespeed-beta"],
        notify => Exec["reload-apache2"]
    }

}
