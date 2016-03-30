class base::defaults {

    Package {
        ensure 	=> "installed",
        allow_virtual => false,
    }
    
    Exec	{ 
        path		=> '/usr/bin:/usr/sbin:/bin:/sbin',
    }
    
    # Set default service provider to systemd, vast majority of companion systems use it
    Service {
        provider    => "systemd"
    }

    # Activate puppetlabs-stdlib at the first opportunity
    class { "stdlib": }

}
