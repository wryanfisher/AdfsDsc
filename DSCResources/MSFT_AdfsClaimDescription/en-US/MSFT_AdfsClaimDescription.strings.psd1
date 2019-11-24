# culture="en-US"
ConvertFrom-StringData @'
    TestingResourceMessage                    = Testing '{0}'. (CD001)
    SettingResourceMessage                    = Setting '{0}'. (CD002)
    SettingResourcePropertyMessage            = Setting '{0}' property '{1}' to '{2}'. (CD003)
    AddingResourceMessage                     = Adding '{0}'. (CD004)
    RemovingResourceMessage                   = Removing '{0}'. (CD005)
    ResourceInDesiredStateMessage             = '{0}' is in the desired state. (CD005)
    ResourceNotInDesiredStateMessage          = '{0}' is not in the desired state. (CD006)
    ResourceIsPresentButShouldBeAbsentMessage = '{0}' is present but should be absent. (CD007)
    ResourceIsAbsentButShouldBePresentMessage = '{0}' is absent but should be present. (CD008)

    GettingResourceErrorMessage               = Error getting '{0}'. (CDERR001)
    SettingResourceErrorMessage               = Error setting '{0}'. (CDERR002)
    RemovingResourceErrorMessage              = Error removing '{0}'. (CDERR003)
    AddingResourceErrorMessage                = Error adding '{0}'. (CDERR004)

    TargetResourcePresentDebugMessage         = '{0}' is Present (CDDBG001)
    TargetResourceAbsentDebugMessage          = '{0}' is Absent (CDDBG002)
    TargetResourceShouldBePresentDebugMessage = '{0}' should be Present (CDDBG003)
    TargetResourceShouldBeAbsentDebugMessage  = '{0}' should be Absent (CDDBG004)
'@
