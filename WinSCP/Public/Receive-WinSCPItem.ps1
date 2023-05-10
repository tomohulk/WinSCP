function Receive-WinSCPItem {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Receive-WinSCPItem",
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
        $RemotePath,

        [Parameter(
            Position = 1
        )]
        [Alias(
            "Destination"
        )]
        [String]
        $LocalPath = $pwd,

        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = (New-Object -TypeName WinSCP.TransferOptions)
    )

    process {
        foreach ($remotePathValue in (Format-WinSCPPathString -Path $($RemotePath))) {
            if (Test-Path -Path $LocalPath) {
                if ((Get-Item -Path $LocalPath).PSIsContainer -and -not $LocalPath.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
                    $LocalPath += [System.IO.Path]::DirectorySeparatorChar
                }

                $LocalPath = Convert-Path -Path (Resolve-Path -Path $LocalPath)
            }

            try {
                $result = $WinSCPSession.GetFiles(
                    $remotePathValue, $LocalPath, $Remove.IsPresent, $TransferOptions
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
