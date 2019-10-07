$Global:DSCModuleName = 'AdfsDsc'
$Global:PSModuleName = 'ADFS'
$Global:DSCResourceName = 'MSFT_AdfsNativeClientApplication'

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
            Get    = 'Get-AdfsNativeClientApplication'
            Set    = 'Set-AdfsNativeClientApplication'
            Add    = 'Add-AdfsNativeClientApplication'
            Remove = 'Remove-AdfsNativeClientApplication'
        }

        $mockResource = @{
            ApplicationGroupIdentifier = 'AppGroup1'
            Name                       = 'NativeApp1'
            Identifier                 = 'NativeApp1'
            RedirectUri                = @('https://nativeapp1.contoso.com')
            Description                = 'App1 Native App'
            LogoutUri                  = 'https://nativeapp1.contoso.com/logout'
            Ensure                     = 'Present'
        }

        $mockAbsentResource = @{
            ApplicationGroupIdentifier = 'AppGroup1'
            Name                       = 'NativeApp1'
            Identifier                 = 'NativeApp1'
            RedirectUri                = @()
            Description                = $null
            LogoutUri                  = $null
            Ensure                     = 'Absent'
        }

        $mockChangedResource = @{
            ApplicationGroupIdentifier = 'AppGroup2'
            Identifier                 = 'Updated NativeApp1'
            RedirectUri                = @('https://nativeapp1.fabrikam.com')
            Description                = 'App1 Updated Native App'
            LogoutUri                  = 'https://nativeapp1.fabrikam.com/logout'
        }

        $mockGetTargetResourceResult = @{
            Name                       = $mockResource.Name
            ApplicationGroupIdentifier = $mockResource.ApplicationGroupIdentifier
            Identifier                 = $mockResource.Identifier
            RedirectUri                = $mockResource.RedirectUri
            Description                = $mockResource.Description
            LogoutUri                  = $mockResource.LogoutUri
        }

        $mockGetTargetResourcePresentResult = $mockGetTargetResourceResult.Clone()
        $mockGetTargetResourcePresentResult.Ensure = 'Present'

        $mockGetTargetResourceAbsentResult = $mockGetTargetResourceResult.Clone()
        $mockGetTargetResourceAbsentResult.Ensure = 'Absent'

        Describe "$Global:DSCResourceName\Get-TargetResource" -Tag 'Get' {
            $getTargetResourceParameters = @{
                Name                       = $mockResource.Name
                ApplicationGroupIdentifier = $mockResource.ApplicationGroupIdentifier
                Identifier                 = $mockResource.Identifier
            }

            $mockGetResourceCommandResult = @{
                Name                       = $mockResource.Name
                ApplicationGroupIdentifier = $mockResource.ApplicationGroupIdentifier
                Identifier                 = $mockResource.Identifier
                RedirectUri                = $mockResource.RedirectUri
                Description                = $mockResource.Description
                LogoutUri                  = $mockResource.LogoutUri
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
                    Assert-MockCalled -CommandName $ResourceCommand.Get `
                        -ParameterFilter { $name -eq $getTargetResourceParameters.Name } `
                        -Exactly -Times 1
                }
            }

            Context 'When the Resource is Absent' {
                Mock -CommandName $ResourceCommand.Get

                $result = Get-TargetResource @getTargetResourceParameters

                foreach ($property in $mockResource.Keys)
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
                    Assert-MockCalled -CommandName $ResourceCommand.Get `
                        -ParameterFilter { $name -eq $getTargetResourceParameters.Name } `
                        -Exactly -Times 1
                }
            }
        }

        Describe "$Global:DSCResourceName\Set-TargetResource" -Tag 'Set' {
            $setTargetResourceParameters = @{
                Name                       = $mockResource.Name
                ApplicationGroupIdentifier = $mockResource.ApplicationGroupIdentifier
                Identifier                 = $mockChangedResource.Identifier
                RedirectUri                = $mockChangedResource.RedirectUri
                Description                = $mockChangedResource.Description
                LogoutUri                  = $mockChangedResource.LogoutUri
            }

            $setTargetResourcePresentParameters = $setTargetResourceParameters.Clone()
            $setTargetResourcePresentParameters.Ensure = 'Present'

            $setTargetResourcePresentAGIChangedParameters = $setTargetResourcePresentParameters.Clone()
            $setTargetResourcePresentAgiChangedParameters.ApplicationGroupIdentifier = $mockChangedResource.ApplicationGroupIdentifier

            $setTargetResourceAbsentParameters = $setTargetResourceParameters.Clone()
            $setTargetResourceAbsentParameters.Ensure = 'Absent'

            Mock -CommandName $ResourceCommand.Set
            Mock -CommandName $ResourceCommand.Add
            Mock -CommandName $ResourceCommand.Remove

            Context 'When the Resource is Present' {
                Mock -CommandName Get-TargetResource -MockWith { $mockGetTargetResourcePresentResult }

                Context 'When the Resource should be Present' {

                    Context 'When the Application Group Identifier has changed' {

                        It 'Should not throw' {
                            { Set-TargetResource @setTargetResourcePresentAGIChangedParameters } | Should -Not -Throw
                        }

                        It 'Should call the expected mocks' {
                            Assert-MockCalled -CommandName Get-TargetResource `
                                -ParameterFilter { `
                                    $ApplicationGroupIdentifier -eq $setTargetResourcePresentAGIChangedParameters.ApplicationGroupIdentifier -and `
                                    $Name -eq $setTargetResourcePresentAGIChangedParameters.Name -and `
                                    $Identifier -eq $setTargetResourcePresentAGIChangedParameters.Identifier } `
                                -Exactly -Times 1
                            Assert-MockCalled -CommandName $ResourceCommand.Set -Exactly -Times 0
                            Assert-MockCalled -CommandName $ResourceCommand.Remove `
                                -ParameterFilter { $TargetName -eq $setTargetResourcePresentParameters.Name } `
                                -Exactly -Times 1
                            Assert-MockCalled -CommandName $ResourceCommand.Add `
                                -ParameterFilter { $Name -eq $setTargetResourcePresentAGIChangedParameters.Name } `
                                -Exactly -Times 1
                        }
                    }

                    Context 'When the Application Group Identifier has not changed' {
                        It 'Should not throw' {
                            { Set-TargetResource @setTargetResourcePresentParameters } | Should -Not -Throw
                        }

                        It 'Should call the expected mocks' {
                            Assert-MockCalled -CommandName Get-TargetResource `
                                -ParameterFilter { `
                                    $ApplicationGroupIdentifier -eq $setTargetResourcePresentParameters.ApplicationGroupIdentifier -and `
                                    $Name -eq $setTargetResourcePresentParameters.Name -and `
                                    $Identifier -eq $setTargetResourcePresentParameters.Identifier } `
                                -Exactly -Times 1
                            Assert-MockCalled -CommandName $ResourceCommand.Set `
                                -ParameterFilter { $TargetName -eq $setTargetResourcePresentParameters.Name } `
                                -Exactly -Times 1
                            Assert-MockCalled -CommandName $ResourceCommand.Remove -Exactly -Times 0
                            Assert-MockCalled -CommandName $ResourceCommand.Add -Exactly -Times 0
                        }
                    }
                }

                Context 'When the Resource should be Absent' {
                    It 'Should not throw' {
                        { Set-TargetResource @setTargetResourceAbsentParameters } | Should -Not -Throw
                    }

                    It 'Should call the expected mocks' {
                        Assert-MockCalled -CommandName Get-TargetResource `
                            -ParameterFilter { `
                                $ApplicationGroupIdentifier -eq $setTargetResourceAbsentParameters.ApplicationGroupIdentifier -and `
                                $Name -eq $setTargetResourceAbsentParameters.Name -and `
                                $Identifier -eq $setTargetResourceAbsentParameters.Identifier } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Remove `
                            -ParameterFilter { $TargetName -eq $setTargetResourceAbsentParameters.Name } `
                            -Exactly -Times 1
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
                            -ParameterFilter { `
                                $ApplicationGroupIdentifier -eq $setTargetResourcePresentParameters.ApplicationGroupIdentifier -and `
                                $Name -eq $setTargetResourcePresentParameters.Name -and `
                                $Identifier -eq $setTargetResourcePresentParameters.Identifier } `
                            -Exactly -Times 1
                        Assert-MockCalled -CommandName $ResourceCommand.Add `
                            -ParameterFilter { $name -eq $setTargetResourcePresentParameters.Name } `
                            -Exactly -Times 1
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
                            -ParameterFilter { `
                                $ApplicationGroupIdentifier -eq $setTargetResourceAbsentParameters.ApplicationGroupIdentifier -and `
                                $Name -eq $setTargetResourceAbsentParameters.Name -and `
                                $Identifier -eq $setTargetResourceAbsentParameters.Identifier } `
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
                Name                       = $mockResource.Name
                ApplicationGroupIdentifier = $mockResource.ApplicationGroupIdentifier
                Identifier                 = $mockResource.Identifier
                RedirectUri                = $mockResource.RedirectUri
                Description                = $mockResource.Description
                LogoutUri                  = $mockResource.LogoutUri
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
                            -ParameterFilter { `
                                $ApplicationGroupIdentifier -eq $testTargetResourcePresentParameters.ApplicationGroupIdentifier -and `
                                $Name -eq $testTargetResourcePresentParameters.Name -and `
                                $Identifier -eq $testTargetResourcePresentParameters.Identifier } `
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
                            -ParameterFilter { `
                                $ApplicationGroupIdentifier -eq $testTargetResourceAbsentParameters.ApplicationGroupIdentifier -and `
                                $Name -eq $testTargetResourceAbsentParameters.Name -and `
                                $Identifier -eq $testTargetResourceAbsentParameters.Identifier } `
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
                            -ParameterFilter { `
                                $ApplicationGroupIdentifier -eq $testTargetResourcePresentParameters.ApplicationGroupIdentifier -and `
                                $Name -eq $testTargetResourcePresentParameters.Name -and `
                                $Identifier -eq $testTargetResourcePresentParameters.Identifier } `
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
                            -ParameterFilter { `
                                $ApplicationGroupIdentifier -eq $testTargetResourceAbsentParameters.ApplicationGroupIdentifier -and `
                                $Name -eq $testTargetResourceAbsentParameters.Name -and `
                                $Identifier -eq $testTargetResourceAbsentParameters.Identifier } `
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