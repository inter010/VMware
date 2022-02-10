echo "Connecting to 127.0.0.1"
$Server="165.246.3.12"
$User="cicinha"
$Password="INHA@cic10"
$Port="10009"
cmdkey /generic:$Server /user:$User /pass:$Password
mstsc /v:$Server":"$Port


$confirmation = Read-Host "Are you Sure You Want To Proceed:"
if ($confirmation -eq 'y') {
    cmdkey /delete:$Server
}