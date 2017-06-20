function Move-WinSCPItem {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Move-WinSCPItem.html"
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
        if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path ($Destination = Format-WinSCPPathString -Path $($Destination)))) {
            if ($Force.IsPresent) {
                New-WinSCPItem -WinSCPSession $WinSCPSession -Path $Destination -ItemType Directory
            } else {
                Write-Error -Message "Cannot find path '$Destination' because it does not exist."
                return
            }
        }

        foreach ($pathValue in (Format-WinSCPPathString -Path $($Path))) {
            try {
                $destinationEndsWithPathValue = $Destination.EndsWith(
                    $pathValue
                )
                $destinationEndsWithForwardSlash = $Destination.EndsWith(
                    "/"
                )
                if (-not ($destinationEndsWithPathValue) -and -not ($destinationEndsWithForwardSlash)) {
                    $Destination += "/"
                }

                $WinSCPSession.MoveFile(
                    $pathValue.TrimEnd(
                        "/"
                    ), $Destination
                )

                if ($PassThru.IsPresent) {
                    Get-WinSCPItem -WinSCPSession $WinSCPSession -Path (Join-Path -Path $Destination -ChildPath (Split-Path -Path $pathValue -Leaf))
                }
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
            }
        }
    }
}
