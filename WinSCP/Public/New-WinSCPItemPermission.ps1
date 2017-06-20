function New-WinSCPItemPermission {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/New-WinSCPItemPermission.html"
    )]
    [OutputType(
        [WinSCP.FilePermissions]
    )]

    param (
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
        $Numeric,

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
        $Text,

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

    $filePermissions = New-Object -TypeName WinSCP.FilePermissions

    foreach ($key in $PSBoundParameters.Keys) {
        try {
            $filePermissions.$($key) = $PSBoundParameters.$($key)
        } catch {
            $PSCmdlet.WriteError(
                $_
            )
        }
    }

    Write-Output -InputObject $filePermissions
}
