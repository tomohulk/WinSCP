<#
.SYNOPSIS
    Escapes special characters in string.
.DESCRIPTION
    Escapes special characters so they are not misinterpreted as wildcards or other special characters.
.INPUTS
   None.
.OUTPUTS
    System.String.
.PARAMETER FileMask
    File path to convert.
.EXAMPLE
    ConvertTo-WinSCPEscapedString -FileMask "*.txt"

    [*].txt
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    $searchString = ConvertTo-WinSCPEscapedString -FileMask "*.txt"
    Receive-WinSCPItem -WinSCPSession $session -RemoteItem "./rDir/$searchString" -LocalItem "C:\lDir\"
.NOTES
    Useful with Send-WinSCPItem, Receive-WinSCPItem, Remove-WinSCPItem cmdlets.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_escapefilemask
#>
Function ConvertTo-WinSCPEscapedString
{
    [CmdletBinding()]
    [OutputType([String])]

    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $FileMask
    )

    Begin
    {
        $sessionObject = New-Object -TypeName WinSCP.Session
    }

    Process
    {
        try
        {
            return ($sessionObject.EscapeFileMask($FileMask))
        }
        catch [System.Exception]
        {
            throw $_
        }
    }
    
    End
    {
        $sessionObject.Dispose()
    }
}