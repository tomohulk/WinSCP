function Send-WinSCPItem {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Send-WinSCPItem",
        PositionalBinding = $false
    )]
    [OutputType(
        [WinSCP.TransferOperationResult]
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
        [Alias(
            "Path"
        )]
        [String[]]
        $LocalPath,

        [Parameter(
            Position = 1
        )]
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
                    $RemotePath += "/"
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
