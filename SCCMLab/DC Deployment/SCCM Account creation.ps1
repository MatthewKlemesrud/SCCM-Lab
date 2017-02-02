#Network Access Account
#The Network Access Account is used by client computers when they cannot use their local computer account to access content on distribution points. For example, this applies to workgroup clients and computers from untrusted domains. This account might also be used during operating system deployment when the computer installing the operating system does not yet have a computer account on the domain.
#Note: The Network Access Account is never used as the security context to run programs, install software updates, or run task sequences; only for accessing resources on the network.
#Grant this account the minimum appropriate permissions on the content that the client requires to access the software. The account must have the Access this computer from the network right on the distribution point or other server that holds the package content. You can configure up to 10 Network Access Accounts per site.
#Create the account in any domain that will provide the necessary access to resources. The Network Access Account must always include a domain name. Pass-through security is not supported for this account. If you have distribution points in multiple domains, create the account in a trusted domain.
$SCCMNetAccessDefault ="SCCM-NetAccess"
$SCCMNetAccess = Get-Credential -Message "Please enter the username and password you wish to use for the Configuration Manager Network Access Account" -UserName $SCCMNetAccessDefault

#Capture Operating System Image Account 
#The Capture Operating System Image Account is used by Configuration Manager to access the folder where captured images are stored when you deploy operating systems. This account is required if you add the step Capture Operating System Image to a task sequence. +
#The account must have Read and Write permissions on the network share where the captured image is stored.
$SCCMImageCaptureDefault ="SCCM-ImageCapture"
$SCCMImageCapture = Get-Credential -Message "Please enter the username and password you wish to use for the Configuration Manager Image Capture Account" -UserName $SCCMImageCaptureDefault

#Management Point Connection Account
#The Management Point Connection Account is used to connect the management point to the Configuration Manager site database so that it can send and retrieve information for clients. By default, the computer account of the management point is used, but you can configure a user account instead. You must specify a user account whenever the management point is in an untrusted domain from the site server.
#Create the account as a low-rights, local account on the computer that runs Microsoft SQL Server.
#Important: Do not grant this account interactive logon rights.

#Client Push Installation Account
#The Client Push Installation Account is used to connect to computers and install the Configuration Manager client software if you deploy clients by using client push installation. If this account is not specified, the site server account is used to try to install the client software.
#This account must be a member of the local Administrators group on the computers where the Configuration Manager client software is to be installed. This account does not require Domain Admin rights.
$SCCMClientPushDefault ="SCCM-ClientPush"
$SCCMClientPush = Get-Credential -Message "Please enter the username and password you wish to use for the Configuration Manager Client Push Account" -UserName $SCCMClientPushDefault

#Reporting Services Point Account
#The Reporting Services Point Account is used by SQL Server Reporting Services to retrieve the data for Configuration Manager reports from the site database. The Windows user account and password that you specify are encrypted and stored in the SQL Server Reporting Services database.

#Task Sequence Editor Domain Joining Account
#The Task Sequence Editor Domain Joining Account is used in a task sequence to join a newly imaged computer to a domain. This account is required if you add the step Join Domain or Workgroup to a task sequence, and then select Join a domain. This account can also be configured if you add the step Apply Network Settings to a task sequence, but it is not required. +
#This account requires the Domain Join right in the domain that the computer will be joining.
$SCCMDomJoinDefault ="SCCM-DomainJoin"
$SCCMDomJoin = Get-Credential -Message "Please enter the username and password you wish to use for the Configuration Manager Domain Join Account" -UserName $SCCMDomJoinDefault

#Task Sequence Editor Network Folder Connection Account
#The Task Sequence Editor Network Folder Connection Account is used by a task sequence to connect to a shared folder on the network. This account is required if you add the step Connect to Network Folder to a task sequence. +
#This account requires permissions to access the specified shared folder and must be a user domain account.
$SCCMTSNetFolderDefault ="SCCM-TSNetFolder"
$SCCMTSNetFolder = Get-Credential -Message "Please enter the username and password you wish to use for the Configuration Manager Task Sequence Network Folder Account" -UserName $SCCMTSNetFolderDefault

#Task Sequence Run As Account
#The Task Sequence Run As Account is used to run command lines in task sequences and use credentials other than the local system account. This account is required if you add the step Run Command Line to a task sequence but do not want the task sequence to run with Local System account permissions on the managed computer. +
#Configure the account to have the minimum permissions required to run the command line that specified in the task sequence. The account requires interactive login rights, and it usually requires the ability to install software and access network resources.
$SCCMTSRunAsDefault ="SCCM-TSRunAs"
$SCCMTSRunAs = Get-Credential -Message "Please enter the username and password you wish to use for the Configuration Manager Task Sequence RunAs Account" -UserName $SCCMTSRunAsDefault

#SQL Server service:
#You can configure the SQL Server service to run using:

#The domain local user account:

#This is a best practice and might require you to manually register the service principal name (SPN) for the account.
#The local system account of the computer that runs SQL Server:

#Use the local system account to simplify the configuration process.
#When you use the local system account, Configuration Manager automatically registers the SPN for the SQL Server service.
#Be aware that using the local system account for the SQL Server service is not a SQL Server best practice.
#When the computer running SQL Server doesn't use its local system account to run the SQL Server service, you must configure the SPN of the account that runs the SQL Server service in Active Directory Domain Services. (When the system account is used, the SPN is automatically registered for you.)
$SCCMSQLServiceDefault ="SCCM-SQLService"
$SCCMSQLService = Get-Credential -Message "Please enter the username and password you wish to use for the Configuration Manager SQL Server Service Account" -UserName $SCCMSQLServiceDefault

#Reporting Services Point Account
#The Reporting Services Point Account is used by SQL Server Reporting Services to retrieve the data for Configuration Manager reports from the site database. The Windows user account and password that you specify are encrypted and stored in the SQL Server Reporting Services database.
$SCCMSQLReportingDefault ="SCCM-SQLReporting"
$SCCMSQLReporting = Get-Credential -Message "Please enter the username and password you wish to use for the Configuration Manager SQL Server Reporting Services Account" -UserName $SCCMSQLReportingDefault

#Software Update Point Proxy Server Account
#The Software Update Point Proxy Server Account is used by the software update point to access the Internet via a proxy server or firewall that requires authenticated access

#Asset Intelligence Synchronization Point Proxy Server Account
#The Asset Intelligence Synchronization Point Proxy Server Account is used by the Asset Intelligence synchronization point to access the Internet via a proxy server or firewall that requires authenticated access.


#Build the table of accounts and credentials
$Accounts = @()
$Accounts += $SCCMSQLReporting
$Accounts += $SCCMSQLService
$Accounts += $SCCMNetAccess
$Accounts += $SCCMImageCapture
$Accounts += $SCCMClientPush
$Accounts += $SCCMDomJoin
$Accounts += $SCCMTSNetFolder
$Accounts += $SCCMTSRunAs

foreach ($Account in $Accounts)
    {
    New-ADUser -Name $Account.UserName -Enabled $true -AccountPassword $Account.password -DisplayName $Account.UserName -UserPrincipalName $Account.UserName
    }

New-ADGroup -Name SCCM-Servers -GroupScope Global
