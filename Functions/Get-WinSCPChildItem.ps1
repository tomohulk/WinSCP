<#
.SYNOPSIS
    Shows the contents of a remote directory.
.DESCRIPTION
    Displays the contents within a remote directory, including other directories and files.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    System.Array.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Path
    Full path to remote directory to be read.
.PARAMETER Filter
    Filter returned objects.
.PARAMETER Recurse
    Return items from all subdirectories.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname 'myftphost.org' -Username 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp) | Get-WinSCPChildItem -Path './rDir/'
    
       Directory: /rDir

    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    D             1/1/2015 12:00:00 AM          0 rSubDir                                                                                                                                                                                                                                     
    -             1/1/2015 12:00:00 AM          0 rTextFile.txt    
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname 'myftphost.org' -Username 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx' | Open-WinSCPSession
    PS C:\> Get-WinSCPChildItem -WinSCPSession $session -Path './rDir/' -Recurse

       Directory: /rDir

    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    D             1/1/2015 12:00:00 AM          0 rSubDir                                                                                                                                                                                                                                     
    -             1/1/2015 12:00:00 AM          0 rTextFile.txt                                                                                                                                                                                                                               


       Directory: /rDir/rSubDir

    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    -             1/1/2015 12:00:00 AM          0 rSubDirTextFile.txt
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_listdirectory
#>
Function Get-WinSCPChildItem
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

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $Path = './',

        [Parameter()]
        [String]
        $Filter = '*',

        [Parameter()]
        [Switch]
        $Recurse
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')

        if(-not ($Path.EndsWith('/')))
        {
            $Path += '/'
        }
    }

    Process
    {
        try
        {
            if (($root = $WinSCPSession.ListDirectory($Path).Files | Where-Object { $_.Name -ne '..' }).Count -gt 0)
            {
                $root | ForEach-Object {
                    $_ | Add-Member -NotePropertyName 'ParentPath' -NotePropertyValue $Path
                }

                $root | Where-Object { $_.Name -like $Filter }
            }

            if ($Recurse.IsPresent)
            {
                foreach ($directory in ($root | Where-Object { $_.IsDirectory }).Name)
                {
                    Get-WinSCPChildItem -WinSCPSession $WinSCPSession -Path ($WinSCPSession.GetFileInfo("$Path$directory").Name) -Recurse -Filter $Filter
                }
            }
        }
        catch [System.Exception]
        {
            Write-Error -ErrorRecord $_

            continue
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