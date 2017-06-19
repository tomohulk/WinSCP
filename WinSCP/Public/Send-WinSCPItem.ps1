function Send-WinSCPItem {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Send-WinSCPItem.html"
    )]
    [OutputType(
        [WinSCP.TransferOperationResult]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
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
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path,

        [Parameter()]
        [String]
        $Destination = $WinSCPSession.HomePath,
        
        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = (New-Object -TypeName WinSCP.TransferOptions)
    )

    process {
        foreach ($pathValue in $Path) {
            if (-not (Test-Path -Path $item)) {
                Write-Error -Message "Cannot find path: $item because it does not exist."

                continue
            }

            $destinationEndsWithForwardSlash = $Destination.EndsWith(
                "/"
            )
            if (-not $destinationEndsWithForwardSlash) {
                if ((Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $Destination -ErrorAction SilentlyContinue).IsDirectory) {
                    $Destination += '/'
                }
            }

            try {
                $result = $WinSCPSession.PutFiles(
                    $pathValue, (Format-WinSCPPathString -Path $($Destination)), $Remove.IsPresent, $TransferOptions
                )

                if ($result.IsSuccess) {
                    Write-Output -InputObject $result
                } else {
                    $result.Failures[0] |
                        Write-Error
                }
            } catch {
                Write-Error -Message $_.ToString()
            }
        }
    }
}
