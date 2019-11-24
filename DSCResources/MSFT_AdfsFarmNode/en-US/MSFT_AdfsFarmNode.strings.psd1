# culture="en-US"
ConvertFrom-StringData @'
    TestingResourceMessage                          = Testing '{0}'. (NDE001)
    SettingResourceMessage                          = Setting '{0}'. (NDE002)
    InstallingResourceMessage                       = Installing '{0}'. (NDE003)
    ResourceInstallSuccessMessage                   = '{0}' has been installed successfully. A reboot is now required. (NDE004)
    ResourceInDesiredStateMessage                   = '{0}' is in the desired state. (NDE005)
    ResourceIsPresentButShouldBeAbsentMessage       = '{0}' is present but should be absent. (NDE006)
    ResourceIsAbsentButShouldBePresentMessage       = '{0}' is absent but should be present. (NDE007)
    MissingAdfsAssembliesMessage                    = Required ADFS assemblies can't be found. Reboot required. (NDE008)
    RemovingResourceMessage                         = Removing '{0}'. (NDE009)

    InstallationErrorMessage                        = '{0}' installation error. (NDEERR001)
    RemovalErrorMessage                             = '{0}' removal error. (NDEERR002)
    ResourceDuplicateCredentialErrorMessage         = Only one of the credential parameters 'ServiceAccountCredential' or 'GroupServiceAccountIdentifier' should be specified for '{0}'. (NDEERR003)
    ResourceMissingCredentialErrorMessage           = One of the credential parameters 'ServiceAccountCredential' or 'GroupServiceAccountIdentifier' must be specified for '{0}'. (NDEERR004)
    GettingAdfsSslCertificateErrorMessage           = Error getting the ADFS SSL Certificate for '{0}'. (NDEERR005)
    GettingAdfsServiceErrorMessage                  = Error getting the ADFS service details for '{0}'. (NDEERR006)
    GettingAdfsSecurityTokenServiceErrorMessage     = Error getting the ADFS Security Token Service details for '{0}'. (NDEERR007)
    GettingAdfsSyncPropertiesErrorMessage           = Error getting the ADFS sync properties for '{0}'. (NDEERR008)
    UnknownAdfsSyncPropertiesObjectTypeErrorMessage = Error unknown AdfsSyncProperties object type '{0}'. (NDEERR009)

    TargetResourcePresentDebugMessage               = '{0}' is Present (NDEDBG001)
    TargetResourceAbsentDebugMessage                = '{0}' is Absent (NDEDBG002)
    TargetResourceShouldBePresentDebugMessage       = '{0}' should be Present (NDEDBG003)
    TargetResourceShouldBeAbsentDebugMessage        = '{0}' should be Absent (NDEDBG004)
'@
