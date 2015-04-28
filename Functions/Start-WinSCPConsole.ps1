<#
.SYNOPSIS
    Opens a new instance of the WinSCP CLI.
.DESCRIPTION
    Opens a new instance of the WinSCP Command Line Interface where raw commands can be executed.
.INPUTS
    None.
.OUTPUTS
    None.
.EXAMPLE
    Start-WinSCPConsole
.NOTES
.LINK
    http://winscp.net/eng/docs/executables
.LINK
    http://dotps1.github.io/WinSCP
#>
Function Start-WinSCPConsole
{
    [CmdletBinding()]
    [OutputType([Void])]

    Param ( )

    $process = "$(Split-Path -Path $MyInvocation.MyCommand.Module.Path)\NeededAssemblies\WinSCP.exe"
    $args = '/Console'

    Start-Process -FilePath $process -ArgumentList $args
}