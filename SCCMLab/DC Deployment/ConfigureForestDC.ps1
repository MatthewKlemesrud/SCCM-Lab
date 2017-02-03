﻿[CmdletBinding()]
Param(
  [Parameter(Mandatory=$false)]
   [string]$DomainName='lab.ads',
	
   [Parameter(Mandatory=$false)]
   [string]$NetBiosName='LAB'
)
Start-Transcript -Path "C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\ConfigureForestDC.log"
Add-WindowsFeature -Name “RSAT-AD-Tools”
Add-WindowsFeature -Name “ad-domain-services” -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name “dns” -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name “gpmc” -IncludeAllSubFeature -IncludeManagementTools

Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false ` 
-DatabasePath “C:\Windows\NTDS” ` 
-DomainMode “Win2012” ` 
-DomainName $domainname ` 
-DomainNetbiosName $netbiosName ` 
-ForestMode “Win2016” ` 
-InstallDns:$true ` 
-LogPath “C:\Windows\NTDS” ` 
-NoRebootOnCompletion:$false ` 
-SysvolPath “C:\Windows\SYSVOL” ` 
-Force:$true`
-whatif
Stop-Transcript