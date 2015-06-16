<#
.SYNOPSIS
    Closes and disposes an active WinSCP Session Object.
.DESCRIPTION
    After a WinSCP Session is no longer needed this function will dispose the COM object.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    None.
.PARAMETER WinSCPSession
    The active WinSCP Session to close.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp) | Close-WinSCPSession
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname 'myftphost.org' -Username 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx' | Open-WinSCPSession
    PS C:\> Close-WinSCPSession -WinSCPSession $session
.NOTES
    If the WinSCPSession is piped into another WinSCP command, this function will be called to auto dispose th connection upon complete of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session
#>
Function Remove-WinSCPSession
{
    [OutputType([Void])]
    
    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [WinSCP.Session]
        $WinSCPSession
    )

    try
    {
        $WinSCPSession.Dispose()
    }
    catch
    {
        Write-Error $_.Exception.InnerException.Message
    }
}