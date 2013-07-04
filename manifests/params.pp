# Class: vod::configs
#
#
#kmode keepalive的角色(master&slave)

class vod::params {
#	if $kmode == "slbmaster" {
#	vod::defconf::kpaldconf { "keepalive":
#			slbiter => eth0,
#			#slbvip => "120.203.215.113/27",
##			slbvip => $slbip,
#			priority => 100,
#			nopreempt => nopreempt,
#		}
#}
#	if $kmode == "slbslave" {
#	vod::defconf::kpaldconf { "keepalive":
#			slbiter => eth0,
#			#slbvip => "120.203.215.113/27",
#			slbvip => $slbip,
#			priority => 150,
#		}
#}
        $smode = 'ms'       #要部署的服务器类型slb ms slbms
        $kmode = 'slbmaster'    #keepalive的模式 master或者slave
        $slbip = '6.6.6.6'
        $superiorip = '2.2.2.2'


}
