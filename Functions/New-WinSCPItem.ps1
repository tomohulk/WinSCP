<#
.SYNOPSIS
    Creates a directory on an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to create new directory or nested directories.
.INPUTS
    WinSCP.Session.
    System.String.
.OUTPUTS
    WinSCP.RemoteFileInfo.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from New-WinSCPSession.
.PARAMETER Path
    Full path to remote directory to create.
.PARAMETER Name
    The name of the new item to be created.  This can be omitted if full path is used to the new item.
.PARAMETER ItemType
    The type of object to be created, IE: File, Directory.
.PARAMETER Value
    Initial value to add to the object being created.
.EXAMPLE
    PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem-Path '/rDir/rSubDir' -ItemType Directory

    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    D             1/1/2015 12:00:00 AM          0 /rDir/rSubDir
.EXAMPLE
    PS C:\> $credential = Get-Credential
    PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> New-WinSCPItem -WinSCPSession $session -Path './rDir' -Name 'rTextFile.txt' -ItemType File -Value 'Hello World!'

    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    -             1/1/2015 12:00:00 AM         12 /rDir/rTextFile.txt
.NOTES
   If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_createdirectory
#>
Function New-WinSCPItem {
    
    [OutputType([WinSCP.RemoteFileInfo])]
    
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

        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [String]
        $Name = $null,

        [Parameter()]
        [ValidateSet(
            'File','Directory'
        )]
        [String]
        $ItemType = 'File',

        [Parameter()]
        [String]
        $Value = $null
    )

    Begin {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process {
        foreach($p in (Format-WinSCPPathString -Path $($Path))) {
            try {
                $newItemParams = @{
                    Path = $env:TEMP
                    ItemType = $ItemType
                    Value = $Value
                    Force = $true
                }

                if ($PSBoundParameters.ContainsKey('Name'))
                {
                    $newItemParams.Add('Name', $Name)
                }

                $result = $WinSCPSession.PutFiles((New-Item @newItemParams).FullName, $p, $true)

                Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $result.Transfers.Destination
            } catch {
                Write-Error -Message $_.ToString()
            }
        }
    }

    End {
        if (-not ($sessionValueFromPipeLine)) {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}