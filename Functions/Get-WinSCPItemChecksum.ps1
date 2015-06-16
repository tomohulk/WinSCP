<#
.SYNOPSIS
    Calculates a checksum of a remote file.
.DESCRIPTION
    Use IANA Algorithm to retrive the checksum of a remote file.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    System.Array.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Algorithm
    A name of a checksum algorithm to use. Use IANA name of algorithm or use a name of any proprietary algorithm the server supports (with SFTP protocol only). Commonly supported algorithms are sha-1 and md5.
.PARAMETER Path
     A full path to a remote file to calculate a checksum for.  
.EXAMPLE
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Get-WinSCPItemChecksum -Algorithm 'sha-1' -Path '/rDir/file.txt'
.NOTES
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_calculatefilechecksum
#>
Function Get-WinSCPItemChecksum
{
    [OutputType([Array])]

    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open)
            { 
                return $true 
            }
            else
            { 
                throw 'The WinSCP Session is not in an Open state.' 
            } })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $Algorithm,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String[]]
        $Path
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach ($item in $Path.Replace('\','/'))
        {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $item))
            {
                Write-Error -Message "Cannot find path: $item because it does not exist."

                continue
            }

            try
            {
                return ($WinSCPSession.CalculateFileChecksum($Algorithm, $item))
            }
            catch
            {
                Write-Error -Message $_.Exception.InnerException.Message
            }
        }
    }
    
    End
    {
        if (-not ($sessionValueFromPipeLine))
        {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}