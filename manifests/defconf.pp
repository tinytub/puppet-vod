# Class: vod::defconf
#
#
class vod::defconf {

        define kpaldconf ( $slbiter, $slbvip, $priority, $nopreempt= '') {
                file {
                "/etc/keepalived/keepalived.conf":
                content => template("vod/keepalived.conf.erb"),
                owner => "root",
                group => "root",
                mode => "644",
                require => Package["keepalived"],
                notify => Service["keepalived"],
                }
        }
        define mvodslb ( $slbvip, $superiorip ) {
                file { 
                "/root/init-SLB.sh":
                content => template("vod/init-SLB.sh.erb"),
                owner => "root",
                group => "root",
                mode => "755",
                require => Exec["unpack_MVOD"]
                }
        }
        define mvodms ( $slbvip ) {
                file { 
                "/root/init-MS.sh":
                content => template("vod/init-MS.sh.erb"),
                owner => "root",
                group => "root",
                mode => "755",
                require => Exec["unpack_MVOD"]
                }
        }
#nginx.conf define
        define nginxconf ( $slbvip ) {
                file { 
                "/usr/local/nginx/conf/nginx.conf":
                content => template("vod/nginx.conf.erb"),
                owner => root,
                group => root,
                mode => 644,
                require => Package["nginx"]
                }
        }
        # Define: lvsdrrs
        # Parameters:
        # arguments
        #
        define lvsdrrs ( $slbvip ) {
                file { 
                "/usr/local/lvs-dr-rs.sh":
                content => template("vod/lvs-dr-rs.sh.erb"),
                owner => root,
                group => root,
                mode  => 755,
                require => Package["nginx"]
                }
        }

}
