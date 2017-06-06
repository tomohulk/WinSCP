function Get-WinSCPChildItem {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Get-WinSCPChildItem.html",
        ParameterSetName = "__AllParameterSets"
    )]
    [OutputType(
        [Array]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
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
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path = "/",

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

        [Parameter(
            ParameterSetName = "Directory"
        )]
        [Switch]
        $Directory,

        [Parameter(
            ParameterSetName = "File"
        )]
        [Switch]
        $File
    )

    begin {
        $sessionValueFromBoundParameter = $PSBoundParameters.ContainsKey(
            "WinSCPSession"
        )
    }

    process {
        foreach ($pathValue in (Format-WinSCPPathString -Path $($Path))) {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $pathValue)) {
                Write-Error -Message "Cannot find path '$pathValue' because it does not exist."
                continue
            }

            $depthParameterUsed = $PSBoundParameters.ContainsKey(
                "Depth"
            )

            if ($depthParameterUsed -and -not $Recurse.IsPresent) {
                $PSBoundParameters.Add(
                    "Recurse", $true
                )
            }

            if ($Recurse.IsPresent) {
                $enumerationOptions = ([WinSCP.EnumerationOptions]::AllDirectories -bor [WinSCP.EnumerationOptions]::MatchDirectories)
            } else {
                $enumerationOptions = ([WinSCP.EnumerationOptions]::None -bor [WinSCP.EnumerationOptions]::MatchDirectories)
            }

            try {
                $items = $WinSCPSession.EnumerateRemoteFiles(
                    $pathValue, $Filter, $enumerationOptions
                ) | 
                    Sort-Object -Property IsDirectory -Descending:$false | 
                        Sort-Object -Property @{ Expression = { Split-Path $_.FullName } }, Name

                if ($depthParameterUsed) {
                    $items = $items.Where({
                        ($_.FullName.SubString(
                            0, $_.FullName.LastIndexOf(
                                [System.IO.Path]::AltDirectorySeparatorChar
                            )
                        ).Split(
                            [System.IO.Path]::AltDirectorySeparatorChar
                        ).Count - 1) -le $Depth
                    })
                }

                switch ($PSCmdlet.ParameterSetName) {
                    "Directory" {
                        $items = $items | Where-Object {
                            $_.IsDirectory -eq $true
                        }
                    }

                    "File" {
                         $items = $items | Where-Object {
                            $_.IsDirectory -eq $false
                        }                       
                    }

                    default { break }
                }

                if ($Name.IsPresent) {
                    $items = $items | 
                        Select-Object -ExpandProperty Name
                }

                Write-Output -InputObject $items
            } catch {
                Write-Error -Message $_.ToString()
            }
        }
    }

    end {
        if (-not ($sessionValueFromBoundParameter)) {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}
