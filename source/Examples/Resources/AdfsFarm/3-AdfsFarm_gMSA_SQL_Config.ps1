<#PSScriptInfo
.VERSION 1.0.0
.GUID 84603b49-5244-4d1f-bd8e-fbabb79ad71b
.AUTHOR DSC Community
.COMPANYNAME DSC Community
.COPYRIGHT (c) DSC Community. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/X-Guardian/AdfsDsc/blob/master/LICENSE
.PROJECTURI https://github.com/X-Guardian/AdfsDsc
.ICONURI https://dsccommunity.org/images/DSC_Logo_300p.png
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES Updated author and copyright notice.
.PRIVATEDATA 2016-Datacenter,2016-Datacenter-Server-Core
#>

#Requires -module AdfsDsc

<#
    .DESCRIPTION
        This configuration will create the first node in an Active Directory Federation Services (AD FS) server farm
        using using a Microsoft SQL Server database on a remote computer named SQLHost.

        The certificate with the specified thumbprint will be used as the SSL certificate and the service
        communications certificate. Automatically generated, self-signed certificates will be used for the token
        signing and token decryption certificates.

        The group Managed Service Account specified in the GroupServiceAccountIdentifier parameter will be used for the
        service account.
#>

Configuration AdfsFarm_gMSA_SQL_Config
{
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $DomainAdminCredential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName AdfsDsc

    Node localhost
    {
        WindowsFeature InstallAdfs
        {
            Name = 'ADFS-Federation'
        }

        AdfsFarm Contoso
        {
            FederationServiceName         = 'fs.corp.contoso.com'
            FederationServiceDisplayName  = 'Contoso ADFS Service'
            CertificateThumbprint         = '8169c52b4ec6e77eb2ae17f028fe5da4e35c0bed'
            GroupServiceAccountIdentifier = 'contoso\adfsgmsa$'
            SQLConnectionString           = 'Data Source=SQLHost;Integrated Security=True'
            Credential                    = $DomainAdminCredential
        }
    }
}
