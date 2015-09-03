<#
.SYNOPSIS
    Represents *nix-style remote file permissions.
.DESCRIPTION
    Creates a new WinSCP.FilePermmissions object that can be used with Send-WinSCPItem to apply permissions.
.INPUTS
    None.
.OUTPUTS
    WinSCP.FilePermissions.
.PARAMETER GroupExecute
    Execute permission for group.
.PARAMETER GroupRead
    Read permission for group.
.PARAMETER GroupWrite
    Read permission for group.
.PARAMETER Numeric
    Permissions as a number.
.PARAMETER Octal
    Permissions in octal format, e.g. "644". Octal format has 3 or 4 (when any special permissions are set) digits.
.PARAMETWER OtherExecute
    Execute permission for others.
.PARAMETER OtherRead
    Read permission for others.
.PARAMETER OtherWrite
    Write permission for others.
.PARAMETER SetGid
    Grants the user, who executes the file, permissions of file group.
.PARAMETER SetUid
    Grants the user, who executes the file, permissions of file owner.
.PARAMETER Sticky
    Sticky bit.
.PARAMETER Text
    Permissions as a text in format "rwxrwxrwx".
.PARAMETER UserExecute
    Execute permission for owner.
.PARAMETER UserRead
    Read permission for owner.
.PARAMETER UserWrite
    Write permission for owner.
.EXAMPLE
    New-WinSCPItemPermission

    Numeric      : 0
    Text         : ---------
    Octal        : 000
    OtherExecute : False
    OtherWrite   : False
    OtherRead    : False
    GroupExecute : False
    GroupWrite   : False
    GroupRead    : False
    UserExecute  : False
    UserWrite    : False
    UserRead     : False
    Sticky       : False
    SetGid       : False
    SetUid       : False
.EXAMPLE
    New-WinSCPItemPermission -GroupExecute -GroupRead -UserExecute -UserRead

    Numeric      : 360
    Text         : r-xr-x---
    Octal        : 550
    OtherExecute : False
    OtherWrite   : False
    OtherRead    : False
    GroupExecute : True
    GroupWrite   : False
    GroupRead    : True
    UserExecute  : True
    UserWrite    : False
    UserRead     : True
    Sticky       : False
    SetGid       : False
    SetUid       : False
.NOTES
    Can only be used with File Uploads.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_filepermissions
#>
Function New-WinSCPItemPermission {

    [OutputType([WinSCP.FilePermissions])]

    Param (
        [Parameter()]
        [Switch]
        $GroupExecute,

        [Parameter()]
        [Switch]
        $GroupRead,

        [Parameter()]
        [Switch]
        $GroupWrite,

        [Parameter()]
        [Int]
        $Numeric = $null,

        [Parameter()]
        [String]
        $Octal = $null,

        [Parameter()]
        [Switch]
        $OtherExecute,

        [Parameter()]
        [Switch]
        $OtherRead,

        [Parameter()]
        [Switch]
        $OtherWrite,

        [Parameter()]
        [Switch]
        $SetGid,

        [Parameter()]
        [Switch]
        $SetUid,

        [Parameter()]
        [Switch]
        $Sticky,

        [Parameter()]
        [String]
        $Text = $null,

        [Parameter()]
        [Switch]
        $UserExecute,

        [Parameter()]
        [Switch]
        $UserRead,

        [Parameter()]
        [Switch]
        $UserWrite
    )

    Begin {
        $filePermmisions = New-Object -TypeName WinSCP.FilePermissions

        foreach ($key in $PSBoundParameters.Keys) {
            try {
                $filePermmisions.$($key) = $PSBoundParameters.$($key)
            } catch {
                Write-Error -Message $_.ToString()
            }
        }
    }

    End {
        return $filePermmisions
    }
}