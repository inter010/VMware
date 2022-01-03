#vCenter접속
$vcenter = "165.246.13.50"
$user = "administrator@vsphere.local"   
$password = "INHA@cic10"
Connect-VIServer -Server $vcenter -user $user -password $password -Protocol https

#신규 VM정보
$name = "test4"          #VM이름
$vm = "TMPLT-WIN2019"            #복제대상 VM
$esxi = "165.246.13.45"        #대상 호스트서버
$ds = "INHA-DataStore_HP02"     #저장 datastore


New-VM -Name $name -Template $vm -Datastore $ds -VMHost $esxi -DiskStorageFormat Thin
#New-NetworkAdapter -vm $name -NetworkName "VLAN15" -Type Vmxnet3 -StartConnected -Confirm:$false

Write-Host "$name VM Create Done..!!" -ForegroundColor DarkYellow
Start-VM -VM $name


Start-Sleep -s 120
#---------------------------------------------------------------------------------------------------


$winScript =@"
New-NetIPAddress -InterfaceAlias "Ethernet1" -IPAddress "165.246.10.254" -PrefixLength 24 -DefaultGateway "165.246.10.1"
Set-DnsClientServerAddress -InterfaceAlias “Ethernet1” -ServerAddresses 165.246.10.2
Rename-Computer -NewName "localhost1123"
Start-Sleep -s 5
Restart-Computer -Force
"@
 
## Invoke Script 실행
# 응답이 없을경우 TCP port 902 오픈필요 
Invoke-VMScript -VM $name -ScriptText $winScript -GuestUser 'cicinha' -GuestPassword 'INHA@cic10' -ScriptType powershell 



#Disconnect-VIServer * -Confirm:$false