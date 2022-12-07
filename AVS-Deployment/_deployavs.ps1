
#Variables
$global:sub = "3988f2d0-8066-42fa-84f2-5d72f80901da" #SubscriptionID
$global:directory = "AVS-Depoyment" #This is where all the files will be downloaded to which will be used to deploy AVS
$global:regionfordeployment = "Australia East"
$global:rgname = "VirtualWorkloads-AVSPrivateCloud-RG" #The REsource Group To Deploy AVS, Can be New or Existing
$global:pcname = "VirtualWorkloads-AVSPrivateCloud" #The name of the AVS Private Cloud
$global:addressblock = "192.168.0.0/22" #The /22 Network Block for AVS Infra
$global:skus = "AV36" #The AVS SKU Type to Deploy
$global:numberofhosts = "3" #This should be left at 3
$global:internet = "Enbabled"



################################################################
#Do Not Edit Below This Line
################################################################
$quickeditsettingatstartofscript = Get-ItemProperty -Path "HKCU:\Console" -Name Quickedit
Set-ItemProperty -Path "HKCU:\Console" -Name Quickedit 0
$quickeditsettingatstartofscript.QuickEdit
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"
$ProgressPreference = 'SilentlyContinue'

##################################
#Create Directory
##################################
mkdir $env:TEMP\$directory -ErrorAction:Ignore

##################################
#Start Logging
##################################
Start-Transcript -Path $env:TEMP\$directory\avsdeploy.log -Append

##################################
#Connect To Azure
##################################
$filename = "ConnectToAzure.ps1"
write-host "Downloading" $filename
Invoke-WebRequest -uri "https://raw.githubusercontent.com/Trevor-Davis/Azure-VMware-Solution/master/AVS-Deployment/$filename" -OutFile $env:TEMP\$directory\$filename
. $env:TEMP\$directory\$filename

##################################
#Register Resource Provider
##################################
$filename = "registeravsresourceprovider.ps1"
write-host "Downloading" $filename
Invoke-WebRequest -uri "https://raw.githubusercontent.com/Trevor-Davis/Azure-VMware-Solution/master/AVS-Deployment/$filename" -OutFile $env:TEMP\$directory\$filename
. $env:TEMP\$directory\$filename

##################################
#Create Resource Group
##################################
$filename = "createresourcegroup.ps1"
write-host "Downloading" $filename
Invoke-WebRequest -uri "https://raw.githubusercontent.com/Trevor-Davis/Azure-VMware-Solution/master/AVS-Deployment/$filename" -OutFile $env:TEMP\$directory\$filename
. $env:TEMP\$directory\$filename 

##################################
#Create Resource Group
##################################
$filename = "kickoffpcbuild.ps1"
write-host "Downloading" $filename
Invoke-WebRequest -uri "https://raw.githubusercontent.com/Trevor-Davis/Azure-VMware-Solution/master/AVS-Deployment/$filename" -OutFile $env:TEMP\$directory\$filename
. $env:TEMP\$directory\$filename 


<#
#Variables
$global:regionfordeployment = "West US"
$global:pcname = "Prod_Private_Cloud"
$global:skus = "AV36"
$global:addressblock = "192.168.4.0/22"
$global:ExrGatewayForAVS = "THIS WILL NEED TO BEPOPULATED BY SCRIPT" ##this only gets filled in for ExpressRoute connected on-prem sites.
$global:VWanHUBNameWithExRGW = "VirtualWorkloads-vWANHub" ##NEW
$global:deployhcxyesorno = "No"
$global:ExrGWforAVSResourceGroup = "VirtualWorkloads"
$global:NameOfOnPremExRCircuit = "prod_express_route" 
$global:ExRGWForAVSRegion = "westus"
$global:AzureConnection = "ExpressRoute"

$global:RGofOnPremExRCircuit = "Prod_AVS_RG"  
$global:internet = "Enabled"
$global:numberofhosts = "3"

$global:RGNewOrExisting = "New" #RGforAVSNewOrExisting
if("New" -eq $global:RGNewOrExisting)
{
$global:rgfordeployment = "Prod_RG"
}
else {
$global:rgfordeployment = "" #rgfordeployment
}


$global:SameSubAVSAndExRGW = "Yes"
if ("Yes" -eq $global:SameSubAVSAndExRGW) {
$global:vnetgwsub = $sub
}
else {
$global:vnetgwsub = ""
}

$global:OnPremExRCircuitSub = ""
$global:OnPremVIServerIP = ""
$global:PSCSameAsvCenterYesOrNo = ""
if ($global:PSCSameAsvCenterYesOrNo -eq "Yes" ) {
  $global:PSCIP = $global:OnPremVIServerIP
}
else {
  $global:PSCIP = ""
}
$global:HCXOnPremRoleMapping = ""

$global:VpnGwVnetName = "" #name of the vNet where the current VPN GW Exists.

$global:RouteServerSubnetAddressPrefix = ""

$global:OnPremCluster = ""

$global:vmotionportgroup =  ""
$global:vmotionprofilegateway = ""
$global:vmotionnetworkmask = ""
$global:vmotionippool = ""

$global:managementportgroup = ""
$global:mgmtprofilegateway = ""
$global:mgmtnetworkmask = ""
$global:mgmtippool = ""

$global:VMNetwork = ""
$global:Datastore = ""

$global:HCXManagerVMName = ""
$global:HCXVMIP = ""
$global:HCXVMNetmask = ""
$global:HCXVMGateway = ""
$global:HCXVMDNS = ""
$global:HCXVMDomain = ""
$global:AVSVMNTP = ""
$global:HCXOnPremLocation = ""
$global:hcxVDS = ""
$global:l2networkextension = ""
     
$global:HCXOnPremUserID = "admin"
     $global:mgmtnetworkprofilename = "Management"
     $global:vmotionnetworkprofilename = "vMotion"
     $global:hcxactivationurl = "https://connect.hcx.vmware.com"
     $global:HCXCloudUserID = "cloudadmin@vsphere.local"
     $global:hcxComputeProfileName = "AVS-ComputeProfile"
     $global:hcxServiceMeshName = "AVS-ServiceMesh"
$global:hcxfilename = "VMware-HCX-Connector-4.3.1.0-19373134.ova"


##Anything being done here is because the variable name needs to exist for other scripts being pulled in.
$global:resourcegroupname = $global:rgfordeployment
$global:region = $global:regionfordeployment
$global:VIServerIP = $global:OnPremVIServerIP
#>