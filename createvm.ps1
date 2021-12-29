#vCenter접속
$vcenter = "165.246.13.50"
$user = "administrator@vsphere.local"   
$password = "INHA@cic10"
Connect-VIServer -Server $vcenter -user $user -password $password -Protocol https

#신규 VM정보
$name = "test2"          #VM이름
$vm = "13.135_oldavamar"            #복제대상 VM
$esxi = "165.246.13.45"        #대상 호스트서버
$ds = "INHA-DataStore_HP02"     #저장 datastore


New-VM -Name $name -vm $vm -Datastore $ds -VMHost $esxi -DiskStorageFormat Thin
New-NetworkAdapter -vm $name -NetworkName "VLAN15" -Type Vmxnet3 -StartConnected -Confirm:$false

Write-Host "$name VM Create Done..!!" -ForegroundColor DarkYellow

Disconnect-VIServer * -Confirm:$false