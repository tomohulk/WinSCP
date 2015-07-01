<#
.SYNOPSIS
    Closes an active WinSCP Session Object.
.DESCRIPTION
    Closes an active WinSCP Session, but does not dispose the object, this object can be re-opened VIA the Open-WinSCPSession cmdlet.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    None.
.PARAMETER WinSCPSession
    The active WinSCP Session to close.
.EXAMPLE
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Close-WinSCPSession
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname 'myftphost.org' -Username 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    
    PS C:\> Close-WinSCPSession -WinSCPSession $session
.NOTES
    None.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session
#>
Function Close-WinSCPSession
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
        $WinSCPSession.Close()
    }
    catch
    {
        Write-Error $_.ToString()
    }
}