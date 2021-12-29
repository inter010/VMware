$csvinput = $args[0]
$maxsession = $args[1]
$runsession = 0

echo "---------------Summary----------------"
echo "This script is to perform the Virtual Storage vMotion with give max sessions"
echo "--------------------------------------"
import-csv $csvinput | foreach {

echo "------------------------------------------------"
echo "Checking the running vMotion now.... Pls wait...."
echo "------------------------------------------------"

Do {

$runsession = (get-task | where {$_.name -like "RelocateVM_Task" -and $_.State -eq "Running" }).count

if ($runsession -ge $maxsession) {
  echo "The current running vMotion sessions is $runsession.No new vMotion will be started.Next check will be performed in 1 minute."
  Start-Sleep -s 60
  get-task | where {$_.State -eq "running"}
  }

else {
  echo "The current running vMotion sessions is $runsession, a new storage vMotion will be started soon."
  Start-Sleep -s 5
  }

} While ( $runsession -ge $maxsession)




echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "The Storage vMotion for will start for below VM ..."
echo $_.vmname
echo $_.targetds
Get-VM $_.vmname | Move-VM -Datastore $_.targetds -RunAsync -Confirm:$false
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

}