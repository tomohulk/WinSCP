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

    Top Folder/Middle Folder/
.EXAMPLE
    Format-WinSCPPathString -Path '.\path\subpath\file.txt'

    path/subpath/file.txt/
.LINK
    http://dotps1.github.io/WinSCP
#>

Function Format-WinSCPPathString {
    [OutputType(
        [String]
    )]

    Param (
        [Parameter(
            Mandatory = $true
        )]
        [String[]]
        $Path
    )

    Process {
        foreach ($item in $Path) {
            if ($item.Contains('\')) {
                $item = $item.Replace('\', '/')
            }

            $item
        }
    }
}