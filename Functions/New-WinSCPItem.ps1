<#
.SYNOPSIS
    Creates a directory on an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to create new directory or nested directories.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.RemoteFileInfo.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Path
    Full path to remote directory to create.
.PARAMETER Name
    The name for the new object to be created.
.PARAMETER ItemType
    The type of object to be created, IE: File, Directory.
.PARAMETER Value
    Initial value to add to the object being created.
.EXAMPLE
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | New-WinSCPItem-Path './rDir' -Name 'rSubDir' -ItemType Directory

    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    D             1/1/2015 12:00:00 AM          0 /rDir/rSubDir
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> New-WinSCPItem -WinSCPSession $session -Path './rDir' -Name 'rTextFile.txt' -ItemType File -Value 'Hello World!'

    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    -             1/1/2015 12:00:00 AM         12 /rDir/rTextFile.txt
.NOTES
   If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_createdirectory
#>
Function New-WinSCPItem
{
    [OutputType([WinSCP.RemoteFileInfo])]
    
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

        [Parameter()]
        [ValidateScript({ if (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $_)
            {
                return $true
            }
            else
            {
                throw "Cannot find the file specified $_."
            } })]
        [String[]]
        $Path = './',


        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $ItemType,

        [Parameter()]
        [ValidateNotNull()]
        [String]
        $Value
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach($item in $Path.Replace('\','/'))
        {
            if (-not ($item.EndsWith('/')))
            {
                $item += '/'
            }

            try
            {
                $object = New-Item -Path $env:TEMP -Name $Name -ItemType $ItemType -Value $Value -Force
                Send-WinSCPItem -WinSCPSession $WinSCPSession -Path $object.FullName -Destination $item | Out-Null

                Get-WinSCPItem -WinSCPSession $WinSCPSession -Path "$item$($object.Name)"
            }
            catch [System.Exception]
            {
                throw $_
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