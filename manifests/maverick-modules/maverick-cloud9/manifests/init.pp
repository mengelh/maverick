class maverick-cloud9 (
    $enabled = true,
    $webport = "6789",
    ) {
    file { "/srv/maverick/software/cloud9":
        ensure 		=> directory,
        require		=> File["/srv/maverick/software"],
	mode		=> 755,
	owner		=> "mav",
	group		=> "mav",
    } ->
    vcsrepo { "/srv/maverick/software/cloud9":
        ensure		=> present,
        provider 	=> git,
        source		=> "https://github.com/c9/core.git",
        revision	=> "master",
	owner		=> "mav",
	group		=> "mav",
        notify		=> [ Exec["install-cloud9"], Exec["install-cloud9-warning"] ]
    } ->
    exec { "install-cloud9-warning":
        command		=> "/bin/echo 'Warning: First run of cloud9 install can take a long time, be patient..'",
        logoutput	=> true,
        refreshonly	=> true,
    } ->
    exec { "install-cloud9":
        command		=> "/srv/maverick/software/cloud9/scripts/install-sdk.sh",
        cwd		=> "/srv/maverick/software/cloud9",
        timeout		=> 0,
        refreshonly	=> true,
        user        	=> "mav",
	environment 	=> ["HOME=/home/mav"],
    } ->
    file { "/etc/systemd/system/cloud9.service":
        content     => template("maverick-cloud9/cloud9.service.erb"),
        owner       => "root",
        group       => "root",
        mode        => 644
    } ->
    service { "cloud9":
        ensure      => running,
        enable      => true
    }
    
    maverick-security::firewall::firerule { "cloud9":
        ports       => $webport,
        ips         => hiera("all_ips"),
        proto       => "tcp"
    }
    
}
