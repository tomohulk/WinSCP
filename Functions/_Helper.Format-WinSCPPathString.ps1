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

    ./
.EXAMPLE
    PS C:\> Format-WinSCPPathString -Path 'Top Folder\Middle Folder'

    ./Top Folder/Middle Folder/
.NOTES
    This function always appends a trailing forward slash to paths, even files.  The commands still work with this.
.LINK
    http://dotps1.github.io/WinSCP
#>

Function Format-WinSCPPathString {
    [OutputType([String])]

    Param (
        [Parameter(
            Mandatory = $true
        )]
        [String]
        $Path
    )

    if ($Path.Contains('\')) {
        $Path = $Path.Replace('\','/')
    }

    if (-not ($Path.StartsWith('.'))) {
        $Path = ".$Path"
    }

    if (-not ($Path.ToCharArray()[1] -eq '/')) {
        $Path = $Path.Insert(1, '/')
    }

    if (-not $Path.EndsWith('/')) {
        $Path = "$Path/"
    }

    return $Path
}