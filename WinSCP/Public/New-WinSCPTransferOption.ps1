Function New-WinSCPTransferOption {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        HelpUri = 'https://github.com/dotps1/WinSCP/wiki/New-WinSCPTransferOption'
    )]
    [OutputType(
        [WinSCP.TransferOptions]
    )]

    Param (
        [Parameter()]
        [String]
        $FileMask = $null,

        [Parameter()]
        [WinSCP.FilePermissions]
        $FilePermissions = $null,

        [Parameter()]
        [WinSCP.OverwriteMode]
        $OverwriteMode = (New-Object -TypeName WinSCP.OverwriteMode),

        [Parameter()]
        [Bool]
        $PreserveTimestamp = $true,

        [Parameter()]
        [WinSCP.TransferResumeSupportState]
        $State = (New-Object -TypeName WinSCP.TransferResumeSupportState),

        [Parameter()]
        [Int]
        $Threshold = 100,
        
        [Parameter()]
        [Int]
        $SpeedLimit = 0,

        [Parameter()]
        [WinSCP.TransferMode]
        $TransferMode = (New-Object -TypeName WinSCP.TransferMode)
    )

    Begin {
        $transferOptions = New-Object -TypeName WinSCP.TransferOptions

        if ($PSCmdlet.ShouldProcess($transferOptions)) {
            foreach ($key in $PSBoundParameters.Keys) {
                try {
                    if ($key -eq 'State' -or $key -eq 'Threshold') {
                        $transferOptions.ResumeSupport.$($key) = $PSBoundParameters.$($key)
                    } else {
                        $transferOptions.$($key) = $PSBoundParameters.$($key)
                    }
                } catch {
                    Write-Error -Message $_.ToString()
                }
            }
        }
    }

    End {
        return $transferOptions
    }
}