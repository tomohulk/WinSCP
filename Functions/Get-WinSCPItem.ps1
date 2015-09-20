Function Get-WinSCPItem {
    [OutputType([WinSCP.RemoteFileInfo])]
    
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
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path = '/',

        [Parameter()]
        [String]
        $Filter = '*'
    )

    Begin {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process {
        foreach ($p in (Format-WinSCPPathString -Path $($Path))) {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $p)) {
                Write-Error -Message "Cannot find path: $p because it does not exist."

                continue
            }

            if ($PSBoundParameters.ContainsKey('Filter')) {
                Get-WinSCPChildItem -WinSCPSession $WinSCPSession -Path $p -Filter $Filter
            } else {
                try {
                    $WinSCPSession.GetFileInfo($p)
                } catch {
                    Write-Error -Message $_.ToString()
                }
            }
        }
    }

    End {
        if (-not ($sessionValueFromPipeLine)) {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}