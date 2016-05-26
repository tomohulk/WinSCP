Function Get-WinSCPChildItem {
    [CmdletBinding(
        HelpUri = 'https://github.com/dotps1/WinSCP/wiki/Get-WinSCPChildItem'
    )]
    [OutputType(
        [Array]
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
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path = '/',

        [Parameter()]
        [String]
        $Filter = '*',

        [Parameter()]
        [Switch]
        $Recurse
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

            try {
                $items = foreach ($file in ($WinSCPSession.ListDirectory($item).Files | Where-Object { $_.Name -ne '..' })) {
                    $WinSCPSession.GetFileInfo((Format-WinSCPPathString -Path (Join-Path -Path $item -ChildPath $file)))
                }

                $items | Where-Object { 
                    $_.Name -like $Filter 
                }

                if ($Recurse.IsPresent) {
                    foreach ($directory in ($items | Where-Object { $_.IsDirectory }).Name) {
                        Get-WinSCPChildItem -WinSCPSession $WinSCPSession -Path (Format-WinSCPPathString -Path (Join-Path -Path $item -ChildPath $directory)) -Recurse -Filter $Filter
                    }
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
