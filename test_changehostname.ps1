
$winScript =@"
Rename-Computer -NewName "test3"
Start-Sleep -s 30
Restart-Computer -Force
"@
 
## Invoke Script 실행
# 응답이 없을경우 TCP 902 오픈필요 
Invoke-VMScript -VM "TMPLT-WIN2019" -ScriptText $winScript -GuestUser 'cicinha' -GuestPassword 'INHA@cic10' -ScriptType powershell 



Rename-Computer -NewName "test2"
Start-Sleep -s 3
set-netip