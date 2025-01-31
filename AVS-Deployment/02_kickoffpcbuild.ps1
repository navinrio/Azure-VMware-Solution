azurelogin -subtoconnect $avssub

$test = Get-AzVMwarePrivateCloud -Name $pcname -ResourceGroupName $avsrgname -ErrorAction:Ignore

if ($test.count -eq 1) {
  write-Host -ForegroundColor Blue "
Azure VMware Solution Private Cloud $pcname Is Already Deployed"
}


if ($test.count -eq 0) {

Write-Host -ForegroundColor Green "
Success: The Azure VMware Solution Private Cloud Deployment Has Begun"
Write-Host -ForegroundColor Yellow "
Deployment Status Will Begin To Show Shortly"

New-AzVMWarePrivateCloud -Name $pcname -ResourceGroupName $avsrgname -SubscriptionId $avssub -NetworkBlock $avsaddressblock -Sku $avssku -Location $avsregion -managementclustersize $numberofhosts -Internet $internet -NoWait -AcceptEULA -ErrorAction Stop

Write-Host -foregroundcolor Blue "
The Azure VMware Solution Private Cloud $pcname deployment is underway and will take approximately 4 hours."
Write-Host -foregroundcolor Yellow "
The status of the deployment will begin to update in 5 minutes."

Start-Sleep -Seconds 300

$provisioningstate = Get-AzVMwarePrivateCloud -Name $pcname -ResourceGroupName $avsrgname
$currentprovisioningstate = $provisioningstate.ProvisioningState
$timeStamp = Get-Date -Format "hh:mm"

while ("Succeeded" -ne $currentprovisioningstate)
{
$timeStamp = Get-Date -Format "hh:mm"
write-host -foregroundcolor yellow "$timestamp - Current Status: $currentprovisioningstate - Next Update In 10 Minutes"
Start-Sleep -Seconds 600
$provisioningstate = get-azvmwareprivatecloud -Name $pcname -ResourceGroupName $avsrgname
$currentprovisioningstate = $provisioningstate.ProvisioningState
}

if("Succeeded" -eq $currentprovisioningstate)
{
  Write-Host -ForegroundColor Green "
$timestamp - Azure VMware Solution Private Cloud $pcname is successfully deployed"
  
}

if("Failed" -eq $currentprovisioningstate)
{
  Write-Host -ForegroundColor Red "
$timestamp - Current Status: $currentprovisioningstate

There appears to be a problem with the deployment of Azure VMware Solution Private Cloud $pcname in subscription $avssub"

Set-ItemProperty -Path "HKCU:\Console" -Name Quickedit $quickeditsettingatstartofscript.QuickEdit

  Exit

}

}