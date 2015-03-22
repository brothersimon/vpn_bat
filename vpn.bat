@echo off
rem preparation

sc config sharedaccess start= disabled
net stop SharedAccess
sc config remoteaccess start= auto
net start RemoteAccess
net start lanmanserver
net start RemoteRegistry

rem build vpn
netsh ras set user administrator permit
netsh ras ip add range 10.18.1.1 10.18.10.10
netsh ras ip set addrassign pool
netsh routing ip nat install
netsh routing ip nat add interface 本地连接 full
netsh routing ip nat add interface 内部 private

netsh routing ip igmp install
netsh routing ip igmp add interface 内部 igmpprototype=IGMPRTRV3 ifenabled=enable robustvar=2 startupquerycount=2 startupqueryinterval=31 genqueryinterval=125 genqueryresptime=10 lastmemquerycount=2 lastmemqueryinterval=1000 accnonrtralertpkts=YES
netsh routing ip igmp add interface name="本地连接" igmpprototype=IGMPPROXY ifenabled=enable 