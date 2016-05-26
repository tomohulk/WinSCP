Function Remove-WinSCPItem {    
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High',
        HelpUri = 'https://github.com/dotps1/WinSCP/wiki/Remove-WinSCPItem'
    )]
    [OutputType(
        [Void]
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
            ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $Path
    )

    Begin {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process {
        foreach ($item in (Format-WinSCPPathString -Path $($Path))) {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $item)) {
                Write-Error -Message "Cannot find path: $item because it does not exist."

                continue
            }

            if ($PSCmdlet.ShouldProcess($item)) {
                try {
                    $WinSCPSession.RemoveFiles($item) | Out-Null
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
