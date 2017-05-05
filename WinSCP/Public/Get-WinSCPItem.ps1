Function Get-WinSCPItem {
<#
.SYNOPSIS 
Retrieves information about a File or Directory from an active WinSCP Session.
.DESCRIPTION
Retrieves Name, FileType, Length, LastWriteTime, FilePermissions, and IsDirectory Properties on an Item from an Active WinSCP Session.
.PARAMETER WinSCPSession
A valid open WinSCP Session, returned from New-WinSCPSession.
.PARAMETER Path
Specifies a path to one or more locations. Wildcards are permitted. The default location is the home directory of the user making the connection.
.PARAMETER Filter
Filter to be applied to returned objects.
.PARAMETER CommonParameters
This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.
.NOTES
If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.
.LINK
http://dotps1.github.io/WinSCP/Get-WinSCPItem.html
.EXAMPLE   
New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem -Path '/rDir/rSubDir'
.EXAMPLE   
$credential = Get-Credential
$session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
Get-WinSCPItem -WinSCPSession $session -Path '/rDir/rSubDir'
#>    
    [CmdletBinding(
        HelpUri = 'https://github.com/dotps1/WinSCP/wiki/Get-WinSCPItem'
    )]
    [OutputType(
        [WinSCP.RemoteFileInfo]
    )]
    
    Param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript({ 
            if ($_.Opened) { 
                return $true 
            } else { 
                throw 'The WinSCP Session is not in an Open state.'
            }
        })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path = '/',

        [Parameter()]
        [String]
        $Filter = '*'
    )

    Begin {
        $sessionValueFromPipeline = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process {
        foreach ($item in (Format-WinSCPPathString -Path $($Path))) {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $item)) {
                Write-Error -Message "Cannot find path: $item because it does not exist."

                continue
            }

            if ($PSBoundParameters.ContainsKey('Filter')) {
                Get-WinSCPChildItem -WinSCPSession $WinSCPSession -Path $item -Filter $Filter
            } else {
                try {
                    $WinSCPSession.GetFileInfo($item)
                } catch {
                    Write-Error -Message $_.ToString()
                }
            }
        }
    }

    End {
        if (-not ($sessionValueFromPipeline)) {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}