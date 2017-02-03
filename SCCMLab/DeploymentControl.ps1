#Parameter Configuration
[CmdletBinding()]
Param(
#General Parameters
   [Parameter(Mandatory=$True)]
   [string]$subscriptionId,
   
   [Parameter(Mandatory=$True)]
   [string]$resourceGroupName='SCCM-Lab',

   [Parameter(Mandatory=$True)]
   [string]$resourceGroupLocation,

#Iaas Deployment Parameters

   [Parameter(Mandatory=$True)]
   [string]$deploymentName='SCCM-Lab',

   [Parameter(Mandatory=$True)]
   [string]$templateFilePath='C:\SCCM Lab\template.json',

   [Parameter(Mandatory=$True)]
   [string]$parametersFilePath='C:\SCCM Lab\parameters.json',


#Domain Controller Parameters

   [Parameter(Mandatory=$false)]
   [string]$DomainName='lab.ads',
	
   [Parameter(Mandatory=$false)]
   [string]$NetBiosName='LAB',

   [Parameter(Mandatory=$true)]
   $SafeModeAdminPW= (Read-Host -Prompt "Enter the SafeMode Administrator password for the domain controller")
)

$subscriptionId
$resourceGroupName
Start-Sleep
#Deploy IaaS

.\Deploy-AzureResourceGroup.ps1 -subscriptionId $subscriptionId -resourceGroupName $resourceGroupName -resourceGroupLocation $resourceGroupLocation -deploymentName $deploymentName -templateFilePath $templateFilePath -parametersFilePath 'C:\Temp\SCCM Lab\parameters.json'

$SecureSafeModeAdminPW = ConvertTo-SecureString -String $SafeModeAdminPW -force
Set-AzureKeyVaultSecret -VaultName 'Password-Safe' -Name 'DCSafeModeAdminPW' -SecretValue $SafeModeAdminPW -ContentType -WhatIf

#Deploy Domain Controller Script
Login-AzureRmAccount -SubscriptionId $subscriptionId
Select-AzureRmSubscription -SubscriptionId $subscriptionId
Set-AzureRmVMCustomScriptExtension -VMName "TestDC" -ResourceGroupName $resourceGroupName -Name "Deploy_Forest_and_Domain_Controller" -FileUri "https://raw.githubusercontent.com/MatthewKlemesrud/SCCM-Lab/master/SCCMLab/DC%20Deployment/ConfigureForestDC.ps1" -Run "ConfigureForestDC.ps1 -SafeModeAdminPW $SafeModeAdminPW" -Location "West Europe" -ForceRerun:$true


############################################################################
#Remove-AzureRmVMCustomScriptExtension -VMName "TestDC" -ResourceGroupName "TEST-LAB-SCCM-01" -Name "Deploy_Forest_and_Domain_Controller"

#Get-AzureRmVMCustomScriptExtension -ResourceGroupName "TEST-LAB-SCCM-01" -VMName "TestDC" -Name "Deploy_Forest_and_Domain_Controller"
#Get-AzureRmVMAccessExtension -ResourceGroupName "TEST-LAB-SCCM-01" -VMName "TestDC"
#Get-AzureRmVMExtension -ResourceGroupName "TEST-LAB-SCCM-01" -VMName "TestDC"
#Set-AzureRmVMAccessExtension -ResourceGroupName "ResrouceGroup11" -Location "Central US" -VMName "VirtualMachine07" -Name "ContosoTest" -TypeHandlerVersion "2.0" -UserName "PFuller" -Password "Password"
#Set-AzureRmVMAccessExtension -ResourceGroupName "TEST-LAB-SCCM-01" -VMName "TestDC" -Name "ContosoTest" -TypeHandlerVersion "2.0"