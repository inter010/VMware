
$winScript =@"
New-NetIPAddress -InterfaceAlias "Ethernet1" -IPAddress "165.246.13.254" -PrefixLength 24 -DefaultGateway "165.246.12.1"
Rename-Computer -NewName "localhost5"
Start-Sleep -s 5
Restart-Computer -Force
"@
 
## Invoke Script 실행
# 응답이 없을경우 TCP port 902 오픈필요 
Invoke-VMScript -VM "TMPLT-WIN2019" -ScriptText $winScript -GuestUser 'cicinha' -GuestPassword 'INHA@cic10' -ScriptType powershell 



#Rename-Computer -NewName "test2"
#Start-Sleep -s 3
#set-netip
#Set-DnsClientServerAddress -InterfaceAlias “Ethernet1” -ServerAddresses 165.246.10.34