$Global:DSCModuleName = 'AdfsDsc'
$Global:PSModuleName = 'ADFS'
$Global:DSCResourceName = 'MSFT_AdfsRelyingPartyTrust'

$moduleRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $Script:MyInvocation.MyCommand.Path))
if ( (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git',
        (Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'))
}

Import-Module (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force

$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $Global:DSCModuleName `
    -DSCResourceName $Global:DSCResourceName `
    -TestType Unit

try
{
    InModuleScope $Global:DSCResourceName {
        # Import ADFS Stub Module
        Import-Module (Join-Path -Path $PSScriptRoot -ChildPath "Stubs\$($Global:PSModuleName)Stub.psm1") -Force

        # Define Resource Commands
        $ResourceCommand = @{
            Get    = 'Get-AdfsRelyingPartyTrust'
            Set    = 'Set-AdfsRelyingPartyTrust'
            Add    = 'Add-AdfsRelyingPartyTrust'
            Remove = 'Remove-AdfsRelyingPartyTrust'
        }

        $mockResource = @{
            Name                                 = 'Outlook Web App'
            AdditionalAuthenticationRules        = ''
            AdditionalWSFedEndpoint              = ''
            AutoUpdateEnabled                    = $true
            ClaimAccepted                        = ''
            ClaimsProviderName                   = ''
            DelegationAuthorizationRules         = ''
            EnableJWT                            = $true
            Enabled                              = $true
            EncryptClaims                        = $true
            EncryptedNameIdRequired              = $true
            EncryptionCertificate                = ''
            EncryptionCertificateRevocationCheck = 'CheckEndCert'
            Identifier                           = 'https://mail.contoso.com/owa'
            ImpersonationAuthorizationRules      = ''
            IssuanceAuthorizationRules           = ''
            IssuanceTransformRules               = ''
            MetadataUrl                          = ''
            MonitoringEnabled                    = $true
            NotBeforeSkew                        = 1
            Notes                                = 'This is a trust for https://mail.contoso.com/owa'
            ProtocolProfile                      = 'SAML'
            RequestSigningCertificate            = ''
            SamlEndpoint                         = ''
            SamlResponseSignature                = 'AssertionOnly'
            SignatureAlgorithm                   = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
            SignedSamlRequestsRequired           = $true
            SigningCertificateRevocationCheck    = 'CheckEndCert'
            TokenLifetime                        = 1
            WSFedEndpoint                        = 'https://mail.contoso.com/owa'
            Ensure                               = 'Present'
        }

        $mockAbsentResource = @{
            Name                                 = 'Outlook Web App'
            AdditionalAuthenticationRules        = $null
            AdditionalWSFedEndpoint              = @()
            AutoUpdateEnabled                    = $false
            ClaimAccepted                        = @()
            ClaimsProviderName                   = @()
            DelegationAuthorizationRules         = $null
            Enabled                              = $false
            EnableJWT                            = $false
            EncryptClaims                        = $false
            EncryptedNameIdRequired              = $false
            EncryptionCertificate                = $null
            EncryptionCertificateRevocationCheck = 'CheckEndCert'
            Identifier                           = @()
            ImpersonationAuthorizationRules      = $null
            IssuanceAuthorizationRules           = $null
            IssuanceTransformRules               = $null
            MetadataUrl                          = $null
            MonitoringEnabled                    = $false
            NotBeforeSkew                        = 0
            Notes                                = $null
            ProtocolProfile                      = 'SAML'
            RequestSigningCertificate            = @()
            SamlEndpoint                         = @()
            SamlResponseSignature                = 'AssertionOnly'
            SignatureAlgorithm                   = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
            SignedSamlRequestsRequired           = $false
            SigningCertificateRevocationCheck    = 'CheckEndCert'
            TokenLifetime                        = 0
            WSFedEndpoint                        = $null
            Ensure                               = 'Absent'
        }

        $mockChangedResource = @{
            AdditionalAuthenticationRules        = 'changed'
            AdditionalWSFedEndpoint              = 'changed'
            AutoUpdateEnabled                    = $false
            ClaimAccepted                        = 'changed'
            ClaimsProviderName                   = 'changed'
            DelegationAuthorizationRules         = 'changed'
            EnableJWT                            = $false
            Enabled                              = $false
            EncryptClaims                        = $false
            EncryptedNameIdRequired              = $false
            EncryptionCertificate                = 'changed'
            EncryptionCertificateRevocationCheck = 'CheckChain'
            Identifier                           = 'https://mail.fabrikam.com/owa'
            ImpersonationAuthorizationRules      = 'changed'
            IssuanceAuthorizationRules           = 'changed'
            IssuanceTransformRules               = 'changed'
            MetadataUrl                          = 'changed'
            MonitoringEnabled                    = $false
            NotBeforeSkew                        = 0
            Notes                                = 'This is a trust for https://mail.fabrikam.com/owa'
            ProtocolProfile                      = 'WsFederation'
            RequestSigningCertificate            = 'changed'
            SamlEndpoint                         = 'changed'
            SamlResponseSignature                = 'MessageOnly'
            SignatureAlgorithm                   = 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
            SignedSamlRequestsRequired           = $false
            SigningCertificateRevocationCheck    = 'CheckChain'
            TokenLifetime                        = 0
            WSFedEndpoint                        = 'https://mail.fabrikam.com/owa'
        }

        $mockGetTargetResourceResult = @{
            Name                                 = $mockResource.Name
            Enabled                              = $mockResource.Enabled
            Notes                                = $mockResource.Notes
            WSFedEndpoint                        = $mockResource.WSFedEndpoint
            Identifier                           = $mockResource.Identifier
            IssuanceTransformRules               = $mockResource.IssuanceTransformRules
            IssuanceAuthorizationRules           = $mockResource.IssuanceAuthorizationRules
            AdditionalAuthenticationRules        = $mockResource.AdditionalAuthenticationRules
            AdditionalWSFedEndpoint              = $mockResource.AdditionalWSFedEndpoint
            AutoUpdateEnabled                    = $mockResource.AutoUpdateEnabled
            ClaimAccepted                        = $mockResource.ClaimAccepted
            ClaimsProviderName                   = $mockResource.ClaimsProviderName
            DelegationAuthorizationRules         = $mockResource.DelegationAuthorizationRules
            EnableJWT                            = $mockResource.EnableJWT
            EncryptClaims                        = $mockResource.EncryptClaims
            EncryptedNameIdRequired              = $mockResource.EncryptedNameIdRequired
            EncryptionCertificate                = $mockResource.EncryptionCertificate
            EncryptionCertificateRevocationCheck = $mockResource.EncryptionCertificateRevocationCheck
            ImpersonationAuthorizationRules      = $mockResource.ImpersonationAuthorizationRules
            MetadataUrl                          = $mockResource.MetadataUrl
            MonitoringEnabled                    = $mockResource.MonitoringEnabled
            NotBeforeSkew                        = $mockResource.NotBeforeSkew
            ProtocolProfile                      = $mockResource.ProtocolProfile
            RequestSigningCertificate            = $mockResource.RequestSigningCertificate
            SamlEndpoint                         = $mockResource.SamlEndpoint
            SamlResponseSignature                = $mockResource.SamlResponseSignature
            SignatureAlgorithm                   = $mockResource.SignatureAlgorithm
            SignedSamlRequestsRequired           = $mockResource.SignedSamlRequestsRequired
            SigningCertificateRevocationCheck    = $mockResource.SigningCertificateRevocationCheck
            TokenLifetime                        = $mockResource.TokenLifetime
        }

        $mockGetTargetResourcePresentResult = $mockGetTargetResourceResult.Clone()
        $mockGetTargetResourcePresentResult.Ensure = 'Present'

        $mockGetTargetResourceAbsentResult = $mockGetTargetResourceResult.Clone()
        $mockGetTargetResourceAbsentResult.Ensure = 'Absent'

        Describe "$Global:DSCResourceName\Get-TargetResource" -Tag 'Get' {
            $getTargetResourceParameters = @{
                Name = $mockResource.Name
            }

            $mockGetResourceCommandResult = @{
                Name                                 = $mockResource.Name
                Enabled                              = $mockResource.Enabled
                Notes                                = $mockResource.Notes
                WSFedEndpoint                        = $mockResource.WSFedEndpoint
                Identifier                           = $mockResource.Identifier
                IssuanceTransformRules               = $mockResource.IssuanceTransformRules
                IssuanceAuthorizationRules           = $mockResource.IssuanceAuthorizationRules
                AdditionalAuthenticationRules        = $mockResource.AdditionalAuthenticationRules
                AdditionalWSFedEndpoint              = $mockResource.AdditionalWSFedEndpoint
                AutoUpdateEnabled                    = $mockResource.AutoUpdateEnabled
                ClaimsAccepted                       = $mockResource.ClaimAccepted
                ClaimsProviderName                   = $mockResource.ClaimsProviderName
                DelegationAuthorizationRules         = $mockResource.DelegationAuthorizationRules
                EnableJWT                            = $mockResource.EnableJWT
                EncryptClaims                        = $mockResource.EncryptClaims
                EncryptedNameIdRequired              = $mockResource.EncryptedNameIdRequired
                EncryptionCertificate                = $mockResource.EncryptionCertificate
                EncryptionCertificateRevocationCheck = $mockResource.EncryptionCertificateRevocationCheck
                ImpersonationAuthorizationRules      = $mockResource.ImpersonationAuthorizationRules
                MetadataUrl                          = $mockResource.MetadataUrl
                MonitoringEnabled                    = $mockResource.MonitoringEnabled
                NotBeforeSkew                        = $mockResource.NotBeforeSkew
                ProtocolProfile                      = $mockResource.ProtocolProfile
                RequestSigningCertificate            = $mockResource.RequestSigningCertificate
                SamlEndpoints                        = $mockResource.SamlEndpoint
                SamlResponseSignature                = $mockResource.SamlResponseSignature
                SignatureAlgorithm                   = $mockResource.SignatureAlgorithm
                SignedSamlRequestsRequired           = $mockResource.SignedSamlRequestsRequired
                SigningCertificateRevocationCheck    = $mockResource.SigningCertificateRevocationCheck
                TokenLifetime                        = $mockResource.TokenLifetime
            }

            Mock -CommandName Assert-Module
            Mock -CommandName Assert-Command
            Mock -CommandName Assert-AdfsService

            Context 'When the Resource is Present' {
                Mock -CommandName $ResourceCommand.Get -MockWith { $mockGetResourceCommandResult }

                $result = Get-TargetResource @getTargetResourceParameters

                foreach ($property in $mockResource.Keys)
                {
                    It "Should return the correct $property property" {
                        $result.$property | Should -Be $mockResource.$property
                    }
                }

                It 'Should call the expected mocks' {
                    Assert-MockCalled -CommandName Assert-Module `
                        -ParameterFilter { $ModuleName -eq $Global:PSModuleName } `
                        -Exactly -Times 1
                    Assert-MockCalled -CommandName Assert-Command `
                        -ParameterFilter { $Module -eq $Global:PSModuleName -and $Command -eq $ResourceCommand.Get } `
                        -Exactly -Times 1
                    Assert-MockCalled -CommandName Assert-AdfsService -Exactly -Times 1
                    Assert-MockCalled -CommandName $ResourceCommand.Get -Exactly -Times 1
                }
            }

            Context 'When the Resource is Absent' {
                Mock -CommandName $ResourceCommand.Get

                $result = Get-TargetResource @getTargetResourceParameters

                foreach ($property in $mockAbsentResource.Keys)
                {
                    It "Should return the correct $property property" {
                        $result.$property | Should -Be $mockAbsentResource.$property
                    }
                }

                It 'Should call the expected mocks' {
                    Assert-MockCalled -CommandName Assert-Module `
                        -ParameterFilter { $ModuleName -eq $Global:PSModuleName } `
                        -Exactly -Times 1
                    Assert-MockCalled -CommandName Assert-Command `
                        -ParameterFilter { $Module -eq $Global:PSModuleName -and $Command -eq $ResourceCommand.Get } `
                        -Exactly -Times 1
                    Assert-MockCalled -CommandName Assert-AdfsService -Exactly -Times 1
                    Assert-MockCalled -CommandName $ResourceCommand.Get -Exactly -Times 1
                }
            }
        }

        Describe "$Global:DSCResourceName\Set-TargetResource" -Tag 'Set' {
            $setTargetResourceParameters = @{
                Name                                 = $mockResource.Name
                Enabled                              = $mockChangedResource.Enabled
                Notes                                = $mockChangedResource.Notes
                WSFedEndpoint                        = $mockChangedResource.WSFedEndpoint
                Identifier                           = $mockChangedResource.Identifier
                IssuanceTransformRules               = $mockChangedResource.IssuanceTransformRules
                IssuanceAuthorizationRules           = $mockChangedResource.IssuanceAuthorizationRules
                AdditionalAuthenticationRules        = $mockChangedResource.AdditionalAuthenticationRules
                AdditionalWSFedEndpoint              = $mockChangedResource.AdditionalWSFedEndpoint
                AutoUpdateEnabled                    = $mockChangedResource.AutoUpdateEnabled
                ClaimAccepted                        = $mockChangedResource.ClaimAccepted
                ClaimsProviderName                   = $mockChangedResource.ClaimsProviderName
                DelegationAuthorizationRules         = $mockChangedResource.DelegationAuthorizationRules
                EnableJWT                            = $mockChangedResource.EnableJWT
                EncryptClaims                        = $mockChangedResource.EncryptClaims
                EncryptedNameIdRequired              = $mockChangedResource.EncryptedNameIdRequired
                EncryptionCertificate                = $mockChangedResource.EncryptionCertificate
                EncryptionCertificateRevocationCheck = $mockChangedResource.EncryptionCertificateRevocationCheck
                ImpersonationAuthorizationRules      = $mockChangedResource.ImpersonationAuthorizationRules
                MetadataUrl                          = $mockChangedResource.MetadataUrl
                MonitoringEnabled                    = $mockChangedResource.MonitoringEnabled
                NotBeforeSkew                        = $mockChangedResource.NotBeforeSkew
                ProtocolProfile                      = $mockChangedResource.ProtocolProfile
                RequestSigningCertificate            = $mockChangedResource.RequestSigningCertificate
                SamlEndpoint                         = $mockChangedResource.SamlEndpoint
                SamlResponseSignature                = $mockChangedResource.SamlResponseSignature
                SignatureAlgorithm                   = $mockChangedResource.SignatureAlgorithm
                SignedSamlRequestsRequired           = $mockChangedResource.SignedSamlRequestsRequired
                SigningCertificateRevocationCheck    = $mockChangedResource.SigningCertificateRevocationCheck
                TokenLifetime                        = $mockChangedResource.TokenLifetime
            }

            $setTargetResourcePresentParameters = $setTargetResourceParameters.Clone()
            $setTargetResourcePresentParameters.Ensure = 'Present'

            $setTargetResourceAbsentParameters = $setTargetResourceParameters.Clone()
            $setTargetResourceAbsentParameters.Ensure = 'Absent'

            Mock -CommandName $ResourceCommand.Set
            Mock -CommandName $ResourceCommand.Add
            Mock -CommandName $ResourceCommand.Remove

            Context 'When the Resource is Present' {
                Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourcePresentResult }

                Context 'When the Resource should be Present' {
                    It 'Should not throw' {
                        { Set-TargetResource @setTargetResourcePresentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { $Name -eq $setTargetResourcePresentParameters.Name } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Add -Exactly -Times 0
                        Assert-MockCalled -CommandName $ResourceCommand.Remove -Exactly -Times 0
                    }
                }

                Context 'When the Resource should be Absent' {
                    It 'Should not throw' {
                        { Set-TargetResource @setTargetResourceAbsentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { $Name -eq $setTargetResourceAbsentParameters.Name } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Remove -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 0
                        Assert-MockCalled -CommandName $ResourceCommand.Add -Exactly -Times 0
                    }
                }
            }

            Context 'When the Resource is Absent' {
                Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourceAbsentResult }

                Context 'When the Resource should be Present' {
                    It 'Should not throw' {
                        { Set-TargetResource @setTargetResourcePresentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { $Name -eq $setTargetResourcePresentParameters.Name } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Add -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 0
                        Assert-MockCalled -CommandName $ResourceCommand.Remove -Exactly -Times 0
                    }
                }

                Context 'When the Resource should be Absent' {
                    It 'Should not throw' {
                        { Set-TargetResource @setTargetResourceAbsentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { $Name -eq $setTargetResourceAbsentParameters.Name } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Remove -Exactly -Times 0
                        Assert-MockCalled -CommandName $ResourceCommand.Add -Exactly -Times 0
                        Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 0
                    }
                }
            }
        }

        Describe "$Global:DSCResourceName\Test-TargetResource" -Tag 'Test' {
            $testTargetResourceParameters = @{
                Name                                 = $mockResource.Name
                Enabled                              = $mockResource.Enabled
                Notes                                = $mockResource.Notes
                WSFedEndpoint                        = $mockResource.WSFedEndpoint
                Identifier                           = $mockResource.Identifier
                IssuanceTransformRules               = $mockResource.IssuanceTransformRules
                IssuanceAuthorizationRules           = $mockResource.IssuanceAuthorizationRules
                AdditionalAuthenticationRules        = $mockResource.AdditionalAuthenticationRules
                AdditionalWSFedEndpoint              = $mockResource.AdditionalWSFedEndpoint
                AutoUpdateEnabled                    = $mockResource.AutoUpdateEnabled
                ClaimAccepted                        = $mockResource.ClaimAccepted
                ClaimsProviderName                   = $mockResource.ClaimsProviderName
                DelegationAuthorizationRules         = $mockResource.DelegationAuthorizationRules
                EnableJWT                            = $mockResource.EnableJWT
                EncryptClaims                        = $mockResource.EncryptClaims
                EncryptedNameIdRequired              = $mockResource.EncryptedNameIdRequired
                EncryptionCertificate                = $mockResource.EncryptionCertificate
                EncryptionCertificateRevocationCheck = $mockResource.EncryptionCertificateRevocationCheck
                ImpersonationAuthorizationRules      = $mockResource.ImpersonationAuthorizationRules
                MetadataUrl                          = $mockResource.MetadataUrl
                MonitoringEnabled                    = $mockResource.MonitoringEnabled
                NotBeforeSkew                        = $mockResource.NotBeforeSkew
                ProtocolProfile                      = $mockResource.ProtocolProfile
                RequestSigningCertificate            = $mockResource.RequestSigningCertificate
                SamlEndpoint                         = $mockResource.SamlEndpoint
                SamlResponseSignature                = $mockResource.SamlResponseSignature
                SignatureAlgorithm                   = $mockResource.SignatureAlgorithm
                SignedSamlRequestsRequired           = $mockResource.SignedSamlRequestsRequired
                SigningCertificateRevocationCheck    = $mockResource.SigningCertificateRevocationCheck
                TokenLifetime                        = $mockResource.TokenLifetime
            }

            $testTargetResourcePresentParameters = $testTargetResourceParameters.Clone()
            $testTargetResourcePresentParameters.Ensure = 'Present'

            $testTargetResourceAbsentParameters = $testTargetResourceParameters.Clone()
            $testTargetResourceAbsentParameters.Ensure = 'Absent'

            Context 'When the Resource is Present' {
                Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourcePresentResult }

                Context 'When the Resource should be Present' {
                    It 'Should not throw' {
                        { Test-TargetResource @testTargetResourcePresentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { $Name -eq $testTargetResourcePresentParameters.Name } `
                            -Exactly -Times 1
                    }

                    Context 'When all the resource properties are in the desired state' {
                        It 'Should return $true' {
                            Test-TargetResource @testTargetResourcePresentParameters | Should -Be $true
                        }
                    }

                    foreach ($property in $mockChangedResource.Keys)
                    {
                        Context "When the $property resource property is not in the desired state" {
                            $testTargetResourceNotInDesiredStateParameters = $testTargetResourceParameters.Clone()
                            $testTargetResourceNotInDesiredStateParameters.$property = $mockChangedResource.$property

                            It 'Should return $false' {
                                Test-TargetResource @testTargetResourceNotInDesiredStateParameters | Should -Be $false
                            }
                        }
                    }
                }

                Context 'When the Resource should be Absent' {
                    It 'Should not throw' {
                        { Test-TargetResource @testTargetResourceAbsentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { $Name -eq $testTargetResourceAbsentParameters.Name } `
                            -Exactly -Times 1
                    }

                    It 'Should return $false' {
                        Test-TargetResource @testTargetResourceAbsentParameters | Should -Be $false
                    }
                }
            }

            Context 'When the Resource is Absent' {
                Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourceAbsentResult }

                Context 'When the Resource should be Present' {
                    It 'Should not throw' {
                        { Test-TargetResource @testTargetResourcePresentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { $Name -eq $testTargetResourcePresentParameters.Name } `
                            -Exactly -Times 1
                    }

                    It 'Should return $false' {
                        Test-TargetResource @testTargetResourcePresentParameters | Should -Be $false
                    }
                }

                Context 'When the Resource should be Absent' {
                    It 'Should not throw' {
                        { Test-TargetResource @testTargetResourceAbsentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { $Name -eq $testTargetResourceAbsentParameters.Name } `
                            -Exactly -Times 1
                    }

                    It 'Should return $true' {
                        Test-TargetResource @testTargetResourceAbsentParameters | Should -Be $true
                    }
                }
            }
        }
    }
}
finally
{
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
}