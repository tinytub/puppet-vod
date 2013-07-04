# Class: vod::packages
#
#
class vod::packages {
#SLB necessary packages
	$enhancers = $vod::params::smode ? {
	slb	=> ["yum-fastestmirror","sysstat","ntp","net-snmp","mysql.x86_64","mysql-server.x86_64","pcre","pcre-devel"],
	ms 	=> ["yum-fastestmirror","sysstat","ntp","net-snmp","mysql.x86_64","pcre-devel.x86_64","bzip2-devel.x86_64","zlib-devel.x86_64","gcc","apr-util","pcre","pcre-devel"],
	slbms	=> ["cyrus-sasl-md5","cyrus-sasl-devel","pcre","pcre-devel"],
	default => undef,
    	}

	package { $enhancers: ensure => present }

#slb pachages and unpack it
	file { 
		"/tmp/cntv_integrate_MVOD_2012_01_13.tar.bz2":
		mode => 644,
		owner => root,
		group => root,
		ensure => file,
		source => "puppet://$puppetserver/modules/vod/cntv_integrate_MVOD_2012_01_13.tar.bz2",
		notify => Exec["unpack_MVOD"],
	}
	exec { "unpack_MVOD":
		command => "tar jxf /tmp/cntv_integrate_MVOD_2012_01_13.tar.bz2 -C /root",
		#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
		refreshonly => true,
	#	refresh => true,
		require => File["/tmp/cntv_integrate_MVOD_2012_01_13.tar.bz2"],
	}
	file { 
		"/root/pre-soft/Auto-SystemConfigure.sh":
		mode => 755,
		owner => root,
		group => root,
		ensure => file,
		source => "puppet://$puppetserver/modules/vod/Auto-SystemConfigure.sh",
		require => Exec["unpack_MVOD"],
	}

#ipvsadm,keepalived RPM ball
	file { 
		"/tmp/ipvsadm-1.24-10.x86_64.rpm":
		mode => 644,
		owner => root,
		group => root,
		ensure => file,
		source => "puppet://$puppetserver/modules/vod/ipvsadm-1.24-10.x86_64.rpm";
		"/tmp/keepalived-1.1.15-5.el5.x86_64.rpm":
		mode => 644,
		owner => root,
		group => root,
		ensure => file,
		source => "puppet://$puppetserver/modules/vod/keepalived-1.1.15-5.el5.x86_64.rpm";
	}
	package { "ipvsadm":
		source => "/tmp/ipvsadm-1.24-10.x86_64.rpm",
		ensure => installed,
		provider => "rpm",
		require => File["/tmp/ipvsadm-1.24-10.x86_64.rpm"],
	}
	package { "keepalived":
		source => "/tmp/keepalived-1.1.15-5.el5.x86_64.rpm",
		ensure => installed,
		provider => "rpm",
		require => File["/tmp/keepalived-1.1.15-5.el5.x86_64.rpm"],
	}
#slb nginx rpm
	file { 
		"/tmp/nginx-0.7.67-1.x86_64.rpm":
		mode => 644,
		owner => root,
		group => root,
		ensure => file,
		source => "puppet://$puppetserver/modules/vod/nginx-0.7.67-1.x86_64.rpm",
		require => Exec["slbinstall"]
	}
	package { "nginx":
		source => "/tmp/nginx-0.7.67-1.x86_64.rpm",
		ensure => installed,
		provider => "rpm",
		require => File["/tmp/nginx-0.7.67-1.x86_64.rpm"],
		}	

#mysql my.cnf & new usr conf info import
	file { 
		"/etc/my.cnf":
		mode => 644,
		owner => root,
		group => root,
		ensure => file,
		source => "puppet://$puppetserver/modules/vod/my.cnf",
		require => Exec["slbinstall"],
	}
	file { 
		"/tmp/slb_new_usr_conf_info.sql":
		mode => 755,
		owner => root,
		group => root,
		ensure => file,
		source => "puppet://$puppetserver/modules/vod/slb_new_usr_conf_info.sql",
		require => [Exec["slbinstall"],File["/etc/my.cnf"]]
	}
}
