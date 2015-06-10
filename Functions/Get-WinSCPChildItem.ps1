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
    Specifies a path to one or more locations. Wildcards are permitted. The default location is the home directory of the user making the connection.
.PARAMETER Filter
    Filter to be applied to returned objects.
.PARAMETER Recurse
    Return items from all subdirectories.
.EXAMPLE
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Get-WinSCPChildItem -Path './rDir/'
    
       Directory: /rDir

    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    D             1/1/2015 12:00:00 AM          0 rSubDir                                                                                                                                                                                                                                     
    -             1/1/2015 12:00:00 AM          0 rTextFile.txt    
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
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
        [String[]]
        $Path = '/',

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $Filter = '*',

        [Parameter()]
        [Switch]
        $Recurse
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach ($item in $Path.Replace('\','/'))
        {
            if (-not ($item.EndsWith('/')))
            {
                $item += '/'
            }

            try
            {
                if (($root = $WinSCPSession.ListDirectory($item).Files | Where-Object { $_.Name -ne '..' }).Count -gt 0)
                {
                    $root | ForEach-Object {
                        $_ | Add-Member -NotePropertyName 'ParentPath' -NotePropertyValue $item
                    }

                    $root | Where-Object { $_.Name -like $Filter }
                }

                if ($Recurse.IsPresent)
                {
                    foreach ($directory in ($root | Where-Object { $_.IsDirectory }).Name)
                    {
                        Get-WinSCPChildItem -WinSCPSession $WinSCPSession -Path ($WinSCPSession.GetFileInfo("$item$directory").Name) -Recurse -Filter $Filter
                    }
                }
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