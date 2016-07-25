Function Send-WinSCPItem {
    [CmdletBinding(
        HelpUri = 'https://github.com/dotps1/WinSCP/wiki/Send-WinSCPItem'
    )]
    [OutputType(
        [WinSCP.TransferOperationResult]
    )]

    Param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript({ 
            if ($_.Opened) { 
                return $true 
            } else { 
                throw 'The WinSCP Session is not in an Open state.'
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
        $Destination = '/',
        
        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = (New-Object -TypeName WinSCP.TransferOptions)
    )

    Begin {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process {
        foreach ($item in $Path) {
            if (-not (Test-Path -Path $item)) {
                Write-Error -Message "Cannot find path: $item because it does not exist."

                continue
            }

            if (-not ($Destination.EndsWith('/'))) {
                if ((Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $Destination -ErrorAction SilentlyContinue).IsDirectory) {
                    $Destination += '/'
                }
            }

            try {
                $WinSCPSession.PutFiles($item, (Format-WinSCPPathString -Path $($Destination)), $Remove.IsPresent, $TransferOptions)
            } catch {
                Write-Error -Message $_.ToString()
            }
        }
    }

    End {
        if (-not ($sessionValueFromPipeLine)) {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}
