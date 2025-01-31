$test = Get-AzVirtualNetworkGateway -Name $exrgwname -ResourceGroupName $avsvnetgwrgname -ErrorAction Ignore

if ($test.count -eq 1) {
write-Host -ForegroundColor Blue "
$exrgwname Already Exists ... Skipping to Next Step"   
}
  
if ($test.count -eq 0) {
write-host -foregroundcolor Yellow "
Creating ExpressRoute Gateway $exrgwname"
 #Create Gateway Subnet
 $getexpressroutegatewayvnet = Get-AzVirtualNetwork -Name $exrvnetname -ResourceGroupName $avsvnetrgname -ErrorAction Ignore
 
if($getexpressroutegatewayvnet.count -eq 0){
Add-AzVirtualNetworkSubnetConfig -Name $gatewaysubnetname -VirtualNetwork $getexpressroutegatewayvnet -AddressPrefix $gatewaysubnetaddressspace
}
Set-AzVirtualNetwork -VirtualNetwork $getexpressroutegatewayvnet 

#get some info   
 $vnet = Get-AzVirtualNetwork -Name $exrvnetname -ResourceGroupName $avsvnetrgname
 $vnet
 
##  $vnet = Set-AzVirtualNetwork -VirtualNetwork $vnet
# $vnet
 
 $subnet = Get-AzVirtualNetworkSubnetConfig -Name $gatewaysubnetname -VirtualNetwork $vnet
 $subnet
 
 #create public IP
 $pip = New-AzPublicIpAddress -Name $exrgwipname -ResourceGroupName $vnet.ResourceGroupName -Location $vnet.Location -AllocationMethod Dynamic
 $pip
 if ($pip.ProvisioningState -ne "Succeeded"){Write-Host -ForegroundColor Red "Creation of the Public IP Failed"
 Exit}
 
 $ipconf = New-AzVirtualNetworkGatewayIpConfig -Name $exrgwipname -Subnet $subnet -PublicIpAddress $pip
 $ipconf
 
 #create the gateway

Write-Host -ForegroundColor Yellow "
Creating a ExpressRoute Gateway ... this could take 30-40 minutes ..."
$command = New-AzVirtualNetworkGateway -Name $exrgwname -ResourceGroupName $vnet.ResourceGroupName -Location $vnet.Location -IpConfigurations $ipconf -GatewayType Expressroute -GatewaySku Standard
$command | ConvertTo-Json


$test = Get-AzVirtualNetworkGateway -Name $exrgwname -ResourceGroupName $rgname -ErrorAction Ignore
If($test.count -eq 0){
Write-Host -ForegroundColor Red "
ExpressRoute Gateway $exrgwname Failed to Create"
Exit
}
else {
  write-Host -ForegroundColor Green "
ExpressRoute Gateway $exrgwname Successfully Created"
  }
}