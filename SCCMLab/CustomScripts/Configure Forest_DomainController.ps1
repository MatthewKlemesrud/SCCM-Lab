<# Custom Script for Windows #>

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$false)]
   [string]$DomainName='lab.ads',
	
   [Parameter(Mandatory=$false)]
   [string]$NetBiosName='LAB',

   [Parameter(Mandatory=$true)]
   [string]$SafeModeAdminPW
	
)
Start-Transcript -Path "C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\ConfigureForestDC.log"
Add-WindowsFeature -Name “RSAT-AD-Tools”
Add-WindowsFeature -Name “ad-domain-services” -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name “dns” -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name “gpmc” -IncludeAllSubFeature -IncludeManagementTools

$SecureSafeModeAdminPWd = ConvertTo-SecureString -String $SafeModeAdminPW -AsPlainText -Force

Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false `
-DatabasePath “C:\Windows\NTDS” `
-DomainName $domainname `
-DomainNetbiosName $netbiosName `
-InstallDns:$true `
-LogPath “C:\Windows\NTDS” `
-NoRebootOnCompletion:$false `
-SysvolPath “C:\Windows\SYSVOL” `
-SafeModeAdministratorPassword $SecureSafeModeAdminPWd `
-Force:$true

Stop-Transcript