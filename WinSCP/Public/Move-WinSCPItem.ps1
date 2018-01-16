function Move-WinSCPItem {

    [CmdletBinding(
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Move-WinSCPItem",
        PositionalBinding = $false
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

        [Parameter(
            Position = 1
        )]
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
        
        foreach ($pathValue in ( Format-WinSCPPathString -Path $Path )) {
            try {
                $destinationEndsWithPathValue = $Destination.EndsWith(
                    $pathValue
                )
                $destinationEndsWithForwardSlash = $Destination.EndsWith(
                    "/"
                )
                if (-not $destinationEndsWithPathValue -and -not $destinationEndsWithForwardSlash ) {
                    $Destination += "/"
                }

                $WinSCPSession.MoveFile(
                    $pathValue.TrimEnd(
                        "/"
                    ), $Destination
                )

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
