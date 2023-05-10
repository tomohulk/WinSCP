<#
.SYNOPSIS
    Properly formats a path string for WinSCP.
.DESCRIPTION
    This help function is used to properly format a path string for WinSCP to avoid syntax errors.
.INPUTS
    System.String.
.OUTPUTS
    System.String.
.PARAMETER Path
    The path string to be formated.
.EXAMPLE
    Format-WinSCPPathString -Path '\'

    /
.EXAMPLE
    Format-WinSCPPathString -Path 'Top Folder\Middle Folder'

    Top Folder/Middle Folder
.EXAMPLE
    Format-WinSCPPathString -Path '.\path\subpath\file.txt'

    ./path/subpath/file.txt
.LINK
    http://tomohulk.github.io/WinSCP
#>

function Format-WinSCPPathString {

    [OutputType(
        [String]
    )]

    param (
        [Parameter(
            Mandatory = $true
        )]
        [String[]]
        $Path
    )

    process {
        foreach ($item in $Path) {
            if ($item -match [RegEx]::Escape( [System.IO.Path]::DirectorySeparatorChar )) {
                $item = $item.Replace(
                    [System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar
                )
            }

            $itemCharArray = $item.ToCharArray()
            if ($itemCharArray[0] -ne [System.IO.Path]::AltDirectorySeparatorChar -and $itemCharArray[0] -ne '.') {
                $item = [System.IO.Path]::AltDirectorySeparatorChar + $item
            }

            Write-Output -InputObject $item
        }
    }
}
