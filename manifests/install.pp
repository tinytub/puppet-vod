# Class: vod::install
#
#
class vod::install {
if $vod::params::smode == slb {
#install slb
	exec { "slbinstall":
		command => "sh /root/init-SLB.sh",
		#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
		refreshonly => true,
		user => "root",
		require => File["/root/init-SLB.sh"],
		subscribe => File["/root/init-SLB.sh"],
	}
	exec { "mysqlinfo":
		command => "mysql -uroot -psql@megajoy < /tmp/slb_new_usr_conf_info.sql",
		refreshonly => true,
		user => "root",
		require => [File["/tmp/slb_new_usr_conf_info.sql"],Exec["slbinstall"]],
		subscribe => File["/tmp/slb_new_usr_conf_info.sql"],
		#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
		#refreshonly => true,
	}
}
	exec { "AutoSystemConfigure":
		command => "sh /root/pre-soft/Auto-SystemConfigure.sh",
		#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
		refreshonly => true,
		user => "root",
		require => File["/root/pre-soft/Auto-SystemConfigure.sh"],
		subscribe => File["/root/pre-soft/Auto-SystemConfigure.sh"],
	}

if $vod::params::smode == ms {
#install slb
	exec { "msinstall":
		command => "sh /root/init-MS.sh",
		#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
		refreshonly => true,
		user => "root",
		require => File["/root/init-MS.sh"],
		subscribe => File["/root/init-MS.sh"],
	}
}

}

