Function Rename-WinSCPItem {    
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
            Mandatory = $true
        )]
        [String]
        $Path,

        [Parameter(
            Mandatory = $true
        )]
        [String]
        $NewName,

        [Parameter()]
        [Switch]
        $PassThru
    )

    Begin {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process {
        try {
            $p = Get-WinSCPItem -WinSCPSession $WinSCPSession -Path (Format-WinSCPPathString -Path $($Path)) -ErrorAction Stop
            
            if ($NewName.Contains('/') -or $NewName.Contains('\')) {
                $NewName = $NewName.Substring($NewName.LastIndexOfAny('/\'))
            }

            $newPath = "$($p.Name.Substring(0, $p.Name.LastIndexOf('/') + 1))$NewName"
            $WinSCPSession.MoveFile($p.Name, $newPath)

            if ($PassThru.IsPresent) {
                Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $newPath
            }
        } catch {
            Write-Error -Message $_.ToString()
        }
    }

    End {
        if (-not ($sessionValueFromPipeLine)) {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}