Function New-WinSCPItemPermission {
    [OutputType(
        [WinSCP.FilePermissions]
    )]

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