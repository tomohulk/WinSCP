<#
.SYNOPSIS
    Allows configuring any site settings using raw format.
.DESCRIPTION
    Allows for highly customized settings to be added to the New-WinSCPSessionOptions Object.
.INPUTS
    WinSCP.SessionOptions.
.OUTPUTS
    WinSCP.SessionOptions.
.PARAMETER SessionOptions
    The WinSCP.SessionOptions object to add raw settings to.
.PARAMETER RawSettings
    A Hashtable of Settings and Values to add to the WinSCP.SessionOptions Object.
.EXAMPLE
    PS C:\> $so = New-WinSCPSessionOptions -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Add-WinSCPSessionOptionsRawSetting -RawSettings @{ 'Compression' = 1; 'Proxymethod' = 3 }

    Protocol                                     : Ftp
    HostName                                     : myftphost.org
    PortNumber                                   : 0
    UserName                                     : ftpuser
    Password                                     : FtpUserPword
    SecurePassword                               : System.Security.SecureString
    Timeout                                      : 00:00:15
    TimeoutInMilliseconds                        : 15000
    SshHostKeyFingerprint                        : 
    GiveUpSecurityAndAcceptAnySshHostKey         : False
    SshPrivateKeyPath                            : 
    SshPrivateKeyPassphrase                      : 
    FtpMode                                      : Passive
    FtpSecure                                    : None
    WebdavSecure                                 : False
    WebdavRoot                                   : 
    TlsHostCertificateFingerprint                : 
    GiveUpSecurityAndAcceptAnyTlsHostCertificate : False

    PS C:\> $s = Open-WinSCPSession -SessionOptions $so
.NOTES
    These settings can also be configured in the .ini file created in the .\NeededAssembly folder.
    The WinSCP.SessionOptions Object will not show these custom settings.
    There is currently no way to show the added raw settings in the WinSCP.SessionOptions Object.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_sessionoptions_addrawsettings
.LINK
    http://winscp.net/eng/docs/rawsettings
#>
Function Add-WinSCPSessionOptionsRawSetting
{
    [OutputType([WinSCP.SessionOptions])]

    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [WinSCP.SessionOptions]
        $SessionOptions,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [HashTable]
        $RawSettings
    )

    try
    {
        foreach ($key in $RawSettings.Keys)
        {
            $SessionOptions.AddRawSettings($key, $RawSettings[$key])
        }
    }
    catch [System.Exception]
    {
        throw $_
    }

    return $SessionOptions
}