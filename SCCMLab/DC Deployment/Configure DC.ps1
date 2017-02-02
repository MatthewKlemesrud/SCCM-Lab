Add-WindowsFeature -Name “RSAT-AD-Tools”
Add-WindowsFeature -Name “ad-domain-services” -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name “dns” -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name “gpmc” -IncludeAllSubFeature -IncludeManagementTools

$domainname = “klem.ads”
$netbiosName = “KLEM” 
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false `
-DatabasePath “C:\Windows\NTDS” `
-DomainName $domainname `
-DomainNetbiosName $netbiosName `
-InstallDns:$true `
-LogPath “C:\Windows\NTDS” `
-NoRebootOnCompletion:$false `
-SysvolPath “C:\Windows\SYSVOL” `
-Force:$true `
-whatif