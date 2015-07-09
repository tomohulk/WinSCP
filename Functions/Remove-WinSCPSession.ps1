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
    The WinSCP Session to be disposed.
.EXAMPLE
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Remove-WinSCPSession
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -Hostname 'myftphost.org' -Username 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Remove-WinSCPSession -WinSCPSession $session
.NOTES
    None.
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
                   ValueFromPipeline = $true)]
        [WinSCP.Session]
        $WinSCPSession
    )

    try
    {
        $WinSCPSession.Dispose()
    }
    catch
    {
        Write-Error $_.ToString()
    }
}