
# Clone VM

$user = "administrator@vsphere.local"
$password = "Vmware!0"
$vcenter = "110"
$specname = "W7PRO32B"
$dns = "101","12"


# Connect to the vCenter Server
"{0} Connecting to vCenter Server..."
Connect-VIServer -Server $vcenter -user $user -password $password -Protocol https
$spec = Get-OSCustomizationSpec $specname


$list = import-csv "C:\Users\Administrator\Desktop\SH_VDI5.csv"

foreach($col in $list)
{
	$name = $col.name
	$ip = $col.ip
	$ds = $col.datastore
	$template = $col.template
	$esx = $col.esx
	$gateway = $col.gw
	$location = $col.location
	$capacity = $col.capacity
	$format = $col.format	
	

	Get-OSCustomizationNicMapping -Spec $spec | Set-OSCustomizationNicMapping -IpMode UseStaticIp -IpAddress $ip -SubnetMask 255.255.255.0 -DefaultGateway $gateway -Dns $dns
	$vm = New-VM -Name $name -Template $template -OSCustomizationSpec $specname -Datastore $ds -VMHost $esx -Location $location
	Start-vm -vm $vm
}


Disconnect-VIServer -Server * -Force


