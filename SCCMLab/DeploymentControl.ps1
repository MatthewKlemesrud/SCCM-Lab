#Parameter Configuration
[CmdletBinding()]
Param(
#General Parameters
   [Parameter(Mandatory=$True)]
   [string]$subscriptionId,
   
   [Parameter(Mandatory=$false)]
   [string]$resourceGroupName = 'SCCM-Lab',

   [Parameter(Mandatory=$True)]
   [string]$resourceGroupLocation,

   [Parameter(Mandatory=$false)]
   [string]$Path=$PSScriptRoot + '\',

#Iaas Deployment Parameters

   [Parameter(Mandatory=$false)]
   [string]$deploymentName = 'SCCM-Lab',

   [Parameter(Mandatory=$false)]
   [string]$templateFileName='template.json',

   [Parameter(Mandatory=$false)]
   [string]$parametersFileName='parameters.json',

   [Parameter(Mandatory=$false)]
   [string]$templateFilePath=$Path + $templateFileName,

   [Parameter(Mandatory=$false)]
   [string]$parametersFilePath=$Path + $parametersFileName,

#Domain Controller Parameters

   [Parameter(Mandatory=$false)]
   [string]$DomainName='lab.ads',
	
   [Parameter(Mandatory=$false)]
   [string]$NetBiosName='LAB',

   [Parameter(Mandatory=$false)]
   $SecureSafeModeAdminPW=(Read-Host -AsSecureString -Prompt "Enter the SafeMode Administrator password for the domain controller")
)

write-host "#################  ARM Template Deployment Settings ################"
write-host "Subscription ID Has been set to        : " -nonewline
write-host $subscriptionId -ForegroundColor:Green
write-host "Resource Group name has been set to    : " -nonewline
write-host $resourceGroupName -ForegroundColor:Green
write-host "Resource Group location has been set to: " -nonewline
write-host $resourceGroupLocation -ForegroundColor:Green
write-host "Path to template files has been set to : " -nonewline
write-host $Path -ForegroundColor:Green
write-host "Template file name has been set to     : " -nonewline
write-host $templateFileName -ForegroundColor:Green
write-host "Parameters file name has been set to   : " -nonewline
write-host $parametersFileName -ForegroundColor:Green
write-host "The deployment name has been set to    : " -nonewline
write-host $deploymentName -ForegroundColor:Green

Write-Host "The Deploy-AzureResourceGroup.pst script will be run with the above parameters, are you sure you wish to continue?" -ForegroundColor:Red
Start-Sleep
#Deploy IaaS


&$path'Deploy-AzureResourceGroup.ps1' -subscriptionId $subscriptionId -resourceGroupName $resourceGroupName -resourceGroupLocation $resourceGroupLocation -deploymentName $deploymentName -templateFilePath $templateFilePath -parametersFilePath 'C:\Temp\SCCM Lab\parameters.json'


######   Domain Controller Deployment    ####################################
#Deploy Domain Controller Script
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureSafeModeAdminPW)            
$SafeModeAdminPW = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)            

Login-AzureRmAccount -SubscriptionId $subscriptionId
Select-AzureRmSubscription -SubscriptionId $subscriptionId
Set-AzureRmVMCustomScriptExtension -VMName "CM-LAB-DC" -ResourceGroupName $resourceGroupName -Name "Deploy_Forest_and_Domain_Controller" -FileUri "https://raw.githubusercontent.com/MatthewKlemesrud/SCCM-Lab/master/SCCMLab/DC%20Deployment/ConfigureForestDC.ps1" -Run "ConfigureForestDC.ps1 -SafeModeAdminPW $SafeModeAdminPW" -Location "West Europe" -ForceRerun:$true


############################################################################
#Remove-AzureRmVMCustomScriptExtension -VMName "TestDC" -ResourceGroupName "TEST-LAB-SCCM-01" -Name "Deploy_Forest_and_Domain_Controller"

#Get-AzureRmVMCustomScriptExtension -ResourceGroupName "TEST-LAB-SCCM-01" -VMName "TestDC" -Name "Deploy_Forest_and_Domain_Controller"
#Get-AzureRmVMAccessExtension -ResourceGroupName "TEST-LAB-SCCM-01" -VMName "TestDC"
#Get-AzureRmVMExtension -ResourceGroupName "TEST-LAB-SCCM-01" -VMName "TestDC"
#Set-AzureRmVMAccessExtension -ResourceGroupName "ResrouceGroup11" -Location "Central US" -VMName "VirtualMachine07" -Name "ContosoTest" -TypeHandlerVersion "2.0" -UserName "PFuller" -Password "Password"
#Set-AzureRmVMAccessExtension -ResourceGroupName "TEST-LAB-SCCM-01" -VMName "TestDC" -Name "ContosoTest" -TypeHandlerVersion "2.0"