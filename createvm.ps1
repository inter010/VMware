#vCenter접속
$vcenter = "165.246.13.50"
$user = "administrator@vsphere.local"   
$password = "INHA@cic10"
Connect-VIServer -Server $vcenter -user $user -password $password -Protocol https

#CSV파일 위치
$list = Import-Csv "D:\python\VMware\createvm.csv"

<#
#신규 VM정보
$name = "test4"                 #VM이름
$tmplt = "TMPLT-WIN2019"            #복제대상 템플릿 (vm과 템플릿 중 하나만 사용)
$vm = "TMPLT-WIN2019"               #복제대상 VM
$esxi = "165.246.13.45"        #대상 호스트서버
$ds = "INHA-DataStore_HP02"     #저장 datastore
#>

foreach ($cols in $list) {

    #신규 VM정보
    $name = $cols.name                  #VM이름
    $tmplt = $cols.tmplt                #복제대상 템플릿 (vm과 템플릿 중 하나만 사용)
    $vm = $cols.vm                      #복제대상 VM
    $esxi = $cols.esxi                  #대상 호스트서버
    $ds = $cols.ds                      #저장 datastore

    #VM 생성
    New-VM -Name $name -Template $tmplt -Datastore $ds -VMHost $esxi -DiskStorageFormat Thin
    #New-NetworkAdapter -vm $name -NetworkName "VLAN15" -Type Vmxnet3 -StartConnected -Confirm:$false

    Write-Host "$name VM Create Done..!!" -ForegroundColor DarkYellow
    
    Start-VM -VM $name
    
}


#부팅시간 보장을 위한 sleep
#Start-Sleep -s 120


#######################################################네트워크 설정#######################################################

#CSV파일 위치
#$list = Import-Csv "D:\python\VMware\createvm.csv"

foreach ($cols in $list) {
 
    $name = $cols.name                  #VM이름
    $ip = $cols.ip                      #IP
    $gw = $cols.gw                      #gateway
    $hostname = $cols.hostname          #hostname

    $winScript =@"
    New-NetIPAddress -InterfaceAlias "Ethernet1" -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw 
    Rename-Computer -NewName $hostname
    Start-Sleep -s 3
    Restart-Computer -Force
"@
 
    # Guest서버에서 스크립트 실행
    # 응답이 없을경우 TCP port 902 오픈필요 
    Invoke-VMScript -VM $name -ScriptText $winScript -GuestUser 'cicinha' -GuestPassword 'INHA@cic10' -ScriptType powershell 
}

Disconnect-VIServer * -Confirm:$false