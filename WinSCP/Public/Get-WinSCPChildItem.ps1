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
        $Filter = $null,

        [Parameter()]
        [Switch]
        $Recurse,

        [Parameter()]
        [Int]
        $Depth = $null,

        [Parameter()]
        [Switch]
        $Name,

        [Parameter()]
        [Switch]
        $Directory,

        [Parameter()]
        [Switch]
        $File
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

            if ($PSBoundParameters.ContainsKey('Depth') -and -not $Recurse.IsPresent) {
                $Recurse = $true
            }

            try {
                if ($Recurse.IsPresent) {
                    $enumerationOptions = ([WinSCP.EnumerationOptions]::AllDirectories -bor [WinSCP.EnumerationOptions]::MatchDirectories)
                } else {
                    $enumerationOptions = ([WinSCP.EnumerationOptions]::None -bor [WinSCP.EnumerationOptions]::MatchDirectories)
                }

                $items = $WinSCPSession.EnumerateRemoteFiles(
                    $item, $Filter, $enumerationOptions
                ) | Sort-Object -Property IsDirectory -Descending:$false | Sort-Object -Property @{ Expression = { Split-Path $_.FullName } }, Name

                if ($PSBoundParameters.ContainsKey('Depth')) {
                    $items = $items | Where-Object {
                        ($_.FullName.SubString(0, $_.FullName.LastIndexOf([System.IO.Path]::AltDirectorySeparatorChar)).Split([System.IO.Path]::AltDirectorySeparatorChar).Count - 1) -le $Depth
                    }
                }

                if ($Directory.IsPresent -and -not $File.IsPresent) {
                    $items = $items | Where-Object {
                        $_.IsDirectory -eq $true
                    }
                } elseif ($File.IsPresent -and -not $Directory.IsPresent) {
                    $items = $items | Where-Object {
                        $_.IsDirectory -eq $false
                    }
                }

                if ($Name.IsPresent) {
                    $items = $items | Select-Object -ExpandProperty Name
                }

                $items
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
