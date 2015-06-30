<#
.SYNOPSIS
    Opens a previously closed WinSCP Session Object.
.DESCRIPTION
    After using the Close-WinSCPSession cmdlet, the object can then be re-opened using this command
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.Session.
.PARAMETER WinSCPSession
    The closed WinSCP Session to open.
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp

    PS C:\> Close-WinSCPSession -WinSCPSession $session

    PS C:\> Open-WinSCPSession -WinSCPSession $session
.NOTES
    If the Remove-WinSCPSession is used rather then the Close-WinSCPSession, the WinSCPSession Object is removed and then cannot be re-opened and will need to be recreated.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session
#>
Function Remove-WinSCPSession
{
    [OutputType([WinSCP.Session])]
    
    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [WinSCP.Session]
        $WinSCPSession
    )

    try
    {
        $WinSCPSession.Open()

        return $WinSCPSession
    }
    catch
    {
        Write-Error $_.ToString()
    }
}