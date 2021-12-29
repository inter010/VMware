## vCenter Server 정보
$user = "administrator@vsphere.local"
$password = "INHA@cic10"
$vcenter = "165.246.13.50"
 
## Connect vCenter Server
Connect-VIServer -Server $vcenter -user $user -password $password -Protocol https
 
## Deploy VM에 적용할 사용자 정의 파일. windows or Linux
$win_spec = 'win'
 
## 배포할 VM 리스트
$list = import-csv "C:\deploy.csv"
 
foreach($col in $list) {
 
$name = $col.vmname
$ip1 = $col.ip1
$ds = $col.datastore
$template = $col.template
$esxi = $col.esxi
$pg = $col.pg
$gw = $col.gw
$cpu = $col.cpu
$mem = $col.mem
 
$temp = Get-VM $template
 
if($temp.GuestId -match 'windows') {
## Windows Customization & Cloen 
$spec = Get-OSCustomizationSpec -Name $win_spec
Get-OSCustomizationNicMapping -spec $spec | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $ip1 -SubnetMask 255.255.255.0 -DefaultGateway $gw -Dns 168.126.63.1
 
## Clone VM
New-VM -Name $name -VM $template -OSCustomizationSpec $spec -datastore $ds -vmhost $esxi -DiskStorageFormat Thick
 
## Set Network Adapter 1
Get-VM -Name $name | Get-NetworkAdapter | Set-NetworkAdapter -Portgroup $pg -Confirm:$false
 
## Set VM Resources
Get-VM $name | Set-VM -numcpu $cpu -memoryGB $mem -Confirm:$false
 
## Finish & Poweron VM
Write-Host "$name VM Create Done..!!" -ForegroundColor DarkYellow
Start-VM -VM $name
}
 
 
###############################  1차 수행 범위. 우선 전체 대상 VM을 배포 ########################################
 
 
## Set 2nd NIC. 배포 후, vNIC 추가시 생성되는 Adapter 명 확인  
$win_nic = 'Ethernet1'
 
## Change 2nd NIC IP for VM
$list = import-csv "C:\deploy.csv"
 
foreach($col in $list) {
 
$name = $col.vmname
$ip2 = $col.ip2
$naspg = $col.naspg
 
## VM별 vNIC 추가
New-NetworkAdapter -vm $name -NetworkName $naspg -Type Vmxnet3 -StartConnected -Confirm:$false
 
## Set Windows 2nd IP
if($vm.GuestId -match 'windows') {
 
$winScript =@"
netsh interface ipv4 set address $win_nic static $ip2 255.255.255.0
"@
 
## Invoke Script 실행
Invoke-VMScript -VM $name -ScriptText $winScript -ScriptType powershell -GuestUser 'admin user' -GuestPassword 'Password'
 
}
 
## Invoke Script 실행
Invoke-VMScript -VM $name -ScriptText $linScript -ScriptType 'Bash' -GuestUser 'root user' -GuestPassword 'Password'
 
}
}
 
 
Disconnect-VIServer * -Confirm:$false

