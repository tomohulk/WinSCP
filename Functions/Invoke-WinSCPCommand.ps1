<#
.SYNOPSIS
    Invokes a command on an Active WinSCP Session.
.DESCRIPTION
    Invokes a command on the system hosting the FTP/SFTP Service.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.CommandExecutionResult.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Command
    Command to execute.
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname 'myftphost.org' -Username 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx' | Open-WinSCPSession
    Invoke-WinSCPCommand -WinSCPSession $session -Command ("mysqldump --opt -u {0} --password={1} --all-databases | gzip > {2}" -f $dbUsername, $dbPassword, $tempFilePath)
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_executecommand
#>
Function Invoke-WinSCPCommand
{
    [OutputType([WinSCP.CommandExecutionResult])]

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
        [String[]]
        $Command
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach ($commandment in $Command)
        {
            try
            {
                $WinSCPSession.ExecuteCommand($commandment)
            }
            catch [System.Exception]
            {
                Write-Error -ErrorRecord $_

                continue
            }
        }
    }

    End
    {
        if (-not ($sessionValueFromPipeLine))
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}