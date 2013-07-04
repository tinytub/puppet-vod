# Class: vod::configs
#
#
class vod::configs {
        file {
                "/etc/resolv.conf":
                source => "puppet://$puppetserver/modules/vod/resolv.conf",
                recurse => true,
        }
        file {
                "/etc/sysconfig/i18n":
                source => "puppet://$puppetserver/modules/vod/i18n",
                recurse => true,
        }
        
#install default necessary packages        
#        $enhancers = [ "lrzsz", "gcc*", "openssl", "openssl-devel"]
#       package { $enhancers: ensure => installed }

        exec { "reput_localtime":
                command => "cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime",
#               refresh => true,
        }
        exec { "ntpdate_refresh":
                command => "ntpdate us.pool.ntp.org",
#               refresh => true,
        }

#config crontab
        cron { "ntpdate_cron":
                command  => "/usr/sbin/ntpdate us.pool.ntp.org | logger -t NTP",
                user     => "root",
                month    => "*",
                monthday => "*",
                hour     => "0",
                minute   => "31",
        }
#rclocal & crontab config
        file { "/etc/rc.d/rc.local":
                ensure => file,
                owner => "root",
                group => "root",
                mode => "755",
                source => "puppet://$puppetserver/modules/vod/rc.local",
                require => Package["nginx"],
        }
        file { "/var/spool/cron/root":
                ensure => file,
                owner => "root",
                group => "root",
                mode => "600",
                source => "puppet://$puppetserver/modules/vod/crontab",
                require => Package["nginx"],
        }


#config keepalive
        if $vod::params::kmode == "slbmaster" {
        vod::defconf::kpaldconf { "keepalive":
                        slbiter => eth0,
                        #slbvip => "120.203.215.113/27",
                        slbvip => $vod::params::slbip,
                        priority => 100,
                        nopreempt => nopreempt,
                }
}
        if $vod::params::kmode == "slbslave" {
        vod::defconf::kpaldconf { "keepalive":
                        slbiter => eth0,
                        #slbvip => "120.203.215.113/27",
                        slbvip => $vod::params::slbip,
                        priority => 150,
                }
}

#config slb init-SLB.sh
        vod::defconf::mvodslb { "mvodslbsh":
                slbvip => $vod::params::slbip,
                superiorip => $vod::params::superiorip,
                }

#config nginx
        vod::defconf::nginxconf {"nginx":
                slbvip => $vod::params::slbip,
                }
        vod::defconf::lvsdrrs  {"lvsdrrs":
                slbvip => $vod::params::slbip,
                }
}
