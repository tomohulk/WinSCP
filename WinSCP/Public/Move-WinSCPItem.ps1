function Move-WinSCPItem {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Move-WinSCPItem",
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({
            if ($_.Opened) {
                return $true
            } else {
                throw "The WinSCP Session is not in an Open state."
            }
        })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path,

        [Parameter()]
        [String]
        $Destination = $WinSCPSession.HomePath,

        [Parameter()]
        [Switch]
        $Force,

        [Parameter()]
        [Switch]
        $PassThru
    )

    process {
        $Destination = Format-WinSCPPathString -Path $Destination
        $destinationEndsWithForwardSlash = $Destination.EndsWith(
            [System.IO.Path]::AltDirectorySeparatorChar
        )
        $destinationInfo = Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $Destination -ErrorAction SilentlyContinue
        if ($null -ne $destinationInfo) {
            if ($destinationInfo.IsDirectory -and -not $destinationEndsWithForwardSlash) {
                $Destination += "/"
            }
        }

        foreach ($pathValue in ( Format-WinSCPPathString -Path $Path )) {
            try {
                $shouldProcess = $PSCmdlet.ShouldProcess(
                    $pathValue
                )
                if ($shouldProcess) {
                    $WinSCPSession.MoveFile(
                        $pathValue, $Destination
                    )
                }

                if ($PassThru.IsPresent) {
                    Get-WinSCPItem -WinSCPSession $WinSCPSession -Path ( Join-Path -Path $Destination -ChildPath ( Split-Path -Path $pathValue -Leaf ))
                }
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
            }
        }
    }
}
