Function Move-WinSCPItem {
    [OutputType([Void])]
    
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
        $Force,

        [Parameter()]
        [Switch]
        $PassThru
    )

    Begin {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process {
        if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path ($Destination = Format-WinSCPPathString -Path $($Destination)))) {
            if ($Force.IsPresent) {
                New-WinSCPItem -WinSCPSession $WinSCPSession -Path $Destination -ItemType Directory
            } else {
                Write-Error -Message 'Could not find a part of the path.'

                return
            }
        }

        foreach ($p in (Format-WinSCPPathString -Path $($Path))) {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $p)) {
                Write-Error -Message "Cannot find path: $p because it does not exist."

                continue
            }

            try {
                $WinSCPSession.MoveFile($p.TrimEnd('/'), $Destination)

                if ($PassThru.IsPresent) {
                    Get-WinSCPItem -WinSCPSession $WinSCPSession -Path (Join-Path -Path $Destination -ChildPath (Split-Path -Path $p -Leaf))
                }
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