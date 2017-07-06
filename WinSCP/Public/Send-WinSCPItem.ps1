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
        [Alias(
            "Path"
        )]
        [String[]]
        $LocalPath,

        [Parameter()]
        [Alias(
            "Destination"
        )]
        [String]
        $RemotePath = $WinSCPSession.HomePath,
        
        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = (New-Object -TypeName WinSCP.TransferOptions)
    )

    process {
        foreach ($localPathValue in (Convert-Path -Path (Resolve-Path -Path $LocalPath))) {
            if (-not (Test-Path -Path $localPathValue)) {
                Write-Error -Message "Cannot find path '$localPathValue' because it does not exist."
                continue
            }

            $remotePathEndsWithForwardSlash = $RemotePath.EndsWith(
                "/"
            )
            if (-not $remotePathEndsWithForwardSlash) {
                if ((Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $RemotePath -ErrorAction SilentlyContinue).IsDirectory) {
                    $Destination += "/"
                }
            }

            try {
                $result = $WinSCPSession.PutFiles(
                    $localPathValue, (Format-WinSCPPathString -Path $($RemotePath)), $Remove.IsPresent, $TransferOptions
                )

                if ($result.IsSuccess) {
                    Write-Output -InputObject $result
                } else {
                    $result.Failures[0] |
                        Write-Error
                }
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
            }
        }
    }
}
