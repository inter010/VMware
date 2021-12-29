$win_nic = 'test'
$ip2 = 165.246.13.2

$winScript =@"
netsh interface ip set address test static 165.246.13.2 255.255.255.0 165.246.13.1 1
"@
 
## Invoke Script 실행
Invoke-VMScript -VM test2 -ScriptText $winScript -ScriptType powershell -GuestUser 'administrator' -GuestPassword '.inha@thdeh'
 