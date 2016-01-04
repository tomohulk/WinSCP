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
        $sessionValueFromPipeline = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process {
        foreach ($item in (Format-WinSCPPathString -Path $($Path))) {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $Path)) {
                Write-Error -Message "Cannot find path: $item because it does not exist."

                continue
            }

            try {
                $items = $WinSCPSession.EnumerateRemoteFiles(
                    $item, $null, ([WinSCP.EnumerationOptions]::None -bor [WinSCP.EnumerationOptions]::MatchDirectories)
                )

                $items | Where-Object {
                    $_.Name -like $Filter
                } | Sort-Object -Property IsDirectory -Descending:$false | Sort-Object -Property Name

                if ($Recurse.IsPresent) {
                    foreach ($container in ($items | Where-Object { $_.IsDirectory })) {
                        Get-WinSCPChildItem -WinSCPSession $WinSCPSession -Path $container.FullName -Filter $Filter -Recurse 
                    }
                }
            } catch {
                Write-Error -Message $_.ToString()
            }
        }
    }

    End {
        if (-not ($sessionValueFromPipeline)) {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}