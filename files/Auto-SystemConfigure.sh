#!/bin/bash
# filename Auto-CloudEx-RRS-MS-SystemConfigure.sh
# power by Liuyu yezongkun ye.zongkun@cloudex.cn
# www.CloudEx.cn (C) 2010 date from 2010.09.2

cat << EOF
+--------------------------------------------------------------+
| === Welcome to AutoInstall CloudEx-RRS-MS-SystemConfigure ===    |
+--------------------------------------------------------------+
EOF

#Root
if [ `whoami` != "root" ];then
        echo "Installtion this package needs root group."
        exit 1
fi

######################Test System#################################
#dmesg
if [ `dmesg |grep error |wc -l` -eq 1 ];then
	echo "Sytem devices have Error, please check System. "
	exit 1
fi

#NIC
if [ `ifconfig |grep eth|wc -l` -eq 0 ];then
	echo "NIC devices is error , please check it. "
	exit 1
fi
#log
if [ `tail /var/log/messages|grep error|wc -l` -eq 1 ];then
	echo "Messages have error , please check it. "
	exit 1
fi


######################System Configure############################
#Disable ipv6
echo "alias net-pf-10 off" >> /etc/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.conf
/sbin/chkconfig --level 35 ip6tables off
echo "ipv6 is disabled!"

#Disable SELINUX
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
echo "selinux is disabled,you must reboot!".

#vim
#sed -i "8 s/^/alias vi='vim'/" /root/.bashrc
#echo 'syntax on' > /root/.vimrc

#env
if [ `grep "LANG=en" /etc/profile|grep -v grep|wc -l` -ne 1 ]
then
        #echo "export LANG=en" >> /etc/profile
        echo "export LANG=en_US.UTF-8" >> /etc/profile
fi

#zh_cn
>/etc/sysconfig/i18n
echo -ne "
LANG=en_US.UTF-8
SYSFONT=latarcyrheb-sun16
" >> /etc/sysconfig/i18n

#time
echo -ne 'ZONE="Asia/Shanghai"
UTC=false
ARC=false' > /etc/sysconfig/clock
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#sysctl
echo >> /etc/sysctl.conf
echo -ne "
net.ipv4.tcp_max_syn_backlog = 4096
net.core.netdev_max_backlog = 2048
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
" >> /etc/sysctl.conf

sysctl -p /etc/sysctl.conf  1>/dev/null

#ulimit
echo '* - nofile 262143' >> /etc/security/limits.conf

#iptables
echo "options ip_conntrack hashsize=65536" >> /etc/modprobe.conf

#ttys
#sed -i 's/3:2345/#3:2345/g' /etc/inittab
#sed -i 's/4:2345/#4:2345/g' /etc/inittab
#sed -i 's/5:2345/#5:2345/g' /etc/inittab
sed -i 's/6:2345/#6:2345/g' /etc/inittab

#time
#//crontab -l > /tmp/cron.tmp
#//echo "1 * * * * /usr/sbin/ntpdate ntp.app.joy.cn; hwclock -w 1>/dev/null 2>&1" >> /tmp/cron.tmp
#//crontab /tmp/cron.tmp && /bin/rm -f /tmp/cron.tmp

#Deny root login
#//sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
#//echo "Enter root new password:" &&\
#///usr/bin/passwd	root
echo

#HostName
#//if [ `grep localhost /etc/sysconfig/network|wc -l` -eq 1 ]; then
#//echo "Enter the server HOSTNAME:"
#//read svrname
#//sed -i "s/HOSTNAME=localhost.localdomain/HOSTNAME=$svrname/g" /etc/sysconfig/network
#//sed -i "s/HOSTNAME=localhost/HOSTNAME=$svrname/g" /etc/sysconfig/network
#//echo
#//fi

######################User Configure############################
#--------------------useradd wumc---------------
#///usr/sbin/useradd -p "\$1\$NKDUDb1h\$S1oqLE8SO5X/15uz8jbhz." wumc

#Useradd joyuser
#///usr/sbin/useradd joyuser
#//echo "Enter joyuser password:" &&\
#///usr/bin/passwd	joyuser

echo eth0:`ethtool eth0|grep Speed`
echo eth1:`ethtool eth1|grep Speed`
echo

######################Services Configure############################
#snmpd
#//if [ `rpm -qa |grep snmpd |wc -l ` -eq 0 ];then 
#//	echo "snmpd not install!" 
#//else 
#//	/bin/cp -f /root/pre-soft/snmpd.conf /etc/snmp/
	sed 's/-Lsd //' -i /etc/init.d/snmpd
	/sbin/chkconfig --level 345 snmpd on
	service snmpd stop && sleep 3 && service snmpd start
#//fi


#SSH
#//if [ `grep "AllowUsers root@59.151.105.137" /etc/ssh/sshd_config|grep -v grep|wc -l` -ne 1 ]
#//then
#//	echo "AllowUsers joyuser" >> /etc/ssh/sshd_config
#//	echo "AllowUsers root@59.151.105.137" >> /etc/ssh/sshd_config
#//fi

#/bin/cp -f /root/pre-soft/id_rsa.pub /root/.ssh/authorized_keys
#//sed -i 's/PermitRootLogin no/\#PermitRootLogin yes/g' /etc/ssh/sshd_config
#//if [ ! -e /root/.ssh/authorized_keys ]
#//then
#//cat /root/pre-soft/id_rsa.pub >> /root/.ssh/authorized_keys
#//fi
#if [ ! -e /root/.ssh/authorized_keys ]
#then
#	touch /root/.ssh/authorized_keys
#	if [ `grep "monitor.39.net" /root/.ssh/authorized_keys|grep -v grep|wc -l` -ne 1 ]
#	then
#		sed -i 's/PermitRootLogin no/\#PermitRootLogin yes/g' /etc/ssh/sshd_config
#		echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAwB0rfkRnuoFiq/GGufnVo3FzewmhW0zL9Rf/Kq/WExBxSN/QZ5fkTbSFPcNLB7YmHl8IlwOTig9R2MlPGs+r40j7+3bAM0RY1/K0vne3qxFc6nmadzFuh770PP6njeVi/V2uPemq0jUPr1p47UP21GKbxaMlIn2rJ8Z3tEatx4s= root@monitor.39.net' >> /root/.ssh/authorized_keys
#echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEA6blRSLLzOCPOSP+Fdexa6+T8wwS7Dl3q+UB5mV919ad6JwncPlT5I+6geB9OPqMcrTOcPgqy8gzrRlNdxN5dNcDxMIW151u49FLLyOfF2iAIC6Xeia+Q4jpBYHSAN7rTey+z9Z8KkiD0yCyRxekCYuMUmb7+Oei6c6M4Nz/NDb4G8pufik9jQEm+51pFfaUjAmeyZ3Yg7iMTorwlm5mLrsvZShCMvQtW71SGF3xyTnOWFtJSra5AECEt3GsQ4HKI9J1A/EfGA3lKb2ZO7w4/kioaVMxLQk0/ft3MrHb+DTqLJFC+hrjciPyUH4LX2fOvXdoF72O4czOXwJCdLU6e+ihZmO+6z4MVBRX2+GWDJ6adk10B+2aPIJn6HzHZMqhNjk0btyte5dXHWg/AgFfz5h94krK10YZsHM6eYBLnv5LLT6ltKv0V5UkzQO+BVc1Qt/WMmo5sXZOD/ckZ2ywyKyVyWcrdJOK1x1xrISGLtmtUXJwXWVpqeldDToOl/ywDjZWyZm2HentTwYkqNOh0Akt6nCkTNRwuF7bdejxmxmRjtK2nYXmpzPt1VdW1PAN7bO5TmQLKH+K6vRhACC+b7ZDv4UOvIRLgxghf0Vuj89OGLXjpcupDaBRtCqHvZOEZMVecOvzQLhSuxJFsNzv+dvqb+xLycYch5mlLnAbv6ec= vodadmin@59.151.105.137' >> /root/.ssh/authorized_keys
#	fi
#fi
#----------------------------------------
/bin/cp -f /root/pre-soft/cdnlog /etc/logrotate.d/
/bin/cp -f /root/pre-soft/wget /usr/bin/wget && chmod +x /usr/bin/wget

#Boot Services
#echo '#!/bin/bash' > /tmp/chkconfiglist
#chkconfig --list | egrep -v "crond|cpuspeed|network|snmpd|sshd|syslog" | awk '{print $1}' | awk '/./ {print $1}' | awk -F":" '{print "chkconfig --level 12345 ",$1," off" }' >>/tmp/chkconfiglist
#/bin/sh /tmp/chkconfiglist && /bin/rm -f /tmp/chkconfiglist

#tunoff services
for i in `ls /etc/rc3.d/S*`
do
             CURSRV=`echo $i|cut -c 15-`
echo $CURSRV
case $CURSRV in
         crond | cpuspeed | network | snmpd | sshd | syslog )
     echo "Base services, Skip!"
     ;;
     *)
         echo "change $CURSRV to off"
         chkconfig --level 2345 $CURSRV off
         service $CURSRV stop
     ;;
esac
done

############################Update Kernel###########################
#KERNEL=$(uname -a|awk '{print $3}')
#if [ "$KERNEL" != "2.6.37-1" ];then
#	echo "Linux kernel is $KERNEL need update? (y/n)"
#	echo "Warning!! This operation is dangerous!!Please check systeminfo"
#	read YN
#	if [ "$YN" == "y" ];then
#		cd /root/pre-soft/kernel
#		echo "Please input your ISP (ct or cnc)"
#		read ISP
#		if [ "$ISP" == "ct" ];then
#			sh chn-dev64osupdate-aw.sh
#		else
#			sh dev64osupdate-aw.sh
#		fi	
#	fi
#fi

/sbin/chkconfig --level 345 irqbalance on
echo "/usr/sbin/ntpdate pool.ntp.org; hwclock -w " >> /etc/rc.local
##################################################################### 

#//cat /etc/rc.local
#//grep -v "#" /etc/snmp/snmpd.conf |grep -v "^$"
#//wget -V |sed 1q
#//grep -v "#" /etc/ssh/sshd_config |grep -v "^$"
#//crontab -l

echo "Initialize Done. Please reboot the system!"
exit 0
