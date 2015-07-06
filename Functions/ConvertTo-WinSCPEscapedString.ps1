<#
.SYNOPSIS
    Escapes special characters in string.
.DESCRIPTION
    Escapes special characters so they are not misinterpreted as wildcards or other special characters.
.INPUTS
   System.String.
.OUTPUTS
    System.String.
.PARAMETER FileMask
    File path to convert.
.EXAMPLE
    ConvertTo-WinSCPEscapedString -FileMask 'FileWithA*InName.txt'

    FileWithA[*]InName.txt
.EXAMPLE
    $session = New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    $searchString = ConvertTo-WinSCPEscapedString -FileMask 'FileWithA*InName.txt'
    Receive-WinSCPItem -WinSCPSession $session -RemoteItem "/rDir/$searchString" -LocalItem 'C:\lDir\'
.NOTES
    Useful with Send-WinSCPItem, Receive-WinSCPItem, Remove-WinSCPItem cmdlets.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_escapefilemask
#>
Function ConvertTo-WinSCPEscapedString
{
    [OutputType([String])]

    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true)]
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
        catch
        {
            Write-Error -Message $_.ToString()
        }
    }
    
    End
    {
        $sessionObject.Dispose()
    }
}