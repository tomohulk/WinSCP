function Get-WinSCPChildItem {

    [CmdletBinding(
        ConfirmImpact = "Low",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Get-WinSCPChildItem",
        PositionalBinding = $false
    )]
    [OutputType(
        [Array]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
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
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path = $WinSCPSession.HomePath,

        [Parameter()]
        [String]
        $Filter = $null,

        [Parameter()]
        [Switch]
        $Recurse,

        [Parameter()]
        [Int]
        $Depth,

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

    process {
        foreach ($pathValue in ( Format-WinSCPPathString -Path $Path )) {
            $depthParameterUsed = $PSBoundParameters.ContainsKey(
                "Depth"
            )

            if ($depthParameterUsed -and -not $Recurse.IsPresent) {
                $Recurse = $true
            }

            if ($Recurse.IsPresent) {
                $enumerationOptions = [WinSCP.EnumerationOptions]::AllDirectories -bor [WinSCP.EnumerationOptions]::MatchDirectories
            } else {
                $enumerationOptions = [WinSCP.EnumerationOptions]::None -bor [WinSCP.EnumerationOptions]::MatchDirectories
            }

            try {
                $items = $WinSCPSession.EnumerateRemoteFiles(
                    $pathValue, $Filter, $enumerationOptions
                )

                $items = $items |
                    Sort-Object -Property IsDirectory -Descending:$false |
                        Sort-Object -Property @{ Expression = { Split-Path -Path $_.FullName } }, Name

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

                if ($Directory.IsPresent -and $File.IsPresent) {
                    # If both -Directory and -File switches are used, exit the loop and return nothing.
                    # This mimics the functionality of Get-ChildItem.
                    continue
                } elseif ($Directory.IsPresent -and -not $File.IsPresent ) {
                    $items = $items.Where({
                        $_.IsDirectory -eq $true
                    })
                } elseif ($File.IsPresent -and -not $Directory.IsPresent) {
                        $items = $items.Where({
                        $_.IsDirectory -eq $false
                    })
                }

                if ($Name.IsPresent) {
                    $items = $items |
                        Select-Object -ExpandProperty Name
                }

                Write-Output -InputObject $items
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
                continue
            }
        }
    }
}
