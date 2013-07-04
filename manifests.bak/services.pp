# Class: vod::services
#
class vod::services {
	service { "keepalived":
		enable => true,
		ensure => running,
		hasrestart => true,
		hasstatus => true,
		require => [Package["keepalived"],File["/etc/keepalived/keepalived.conf"]],
		subscribe => File["/etc/keepalived/keepalived.conf"],
	}
	service { "nginx":
	    enable => true,
		ensure => running,
		hasstatus => true,
		hasrestart => true,
		#hasrestart => true,
		#hasstatus => true,
		require => [Package["nginx"],File["/usr/local/nginx/conf/nginx.conf"]],
		subscribe => File["/usr/local/nginx/conf/nginx.conf"],
	}
}
