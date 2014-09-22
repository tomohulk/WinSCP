# WinSCP PowerShell Wrapper

This is still a very beta version, with most of the functionality available with WinSCP, I intend on developing this extensively.  

Current avaialbe functions:
```PowerShell
New-WinSCPSessionOptions
Open-WinSCPSession
Close-WinSCPSession
New-WinSCPTransferOptions
Receive-WinSCPItem
Send-WinSCPItem
New-WinSCPDirectory
Test-WinSCPItemExsits
Get-WinSCPItemInformation
Get-WinSCPDirectoryContents
Move-WinSCPItem
Remove-WinSCPItem
Sync-WinSCPDirectory
Invoke-WinSCPCommand
ConvertTo-WinSCPEscapedString
```

Example 1:

```PowerShell
$session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
Send-WinSCPItem -WinSCPSession $session -LocalItem "C:\lDir\lFile.txt" -RemoteItem "rDir/rFile.txt" -RemoveLocalItem
```

Example 2:

```PowerShell
PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Send-WinSCPItem -LocalItem "C:\lDir\lFile.txt" -RemoteItem "rDir/rFile.txt" 
```

Example 3:

```PowerShell
$session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
Receive-WinSCPItem -WinSCPSession $session -RemoteItem "rDir/rFile.txt" -LocalItem "C:\lDir\lFile.txt" -RemoveRemoteItem
```

Example 4:

```PowerShell
$session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
Sync-WinSCPDirectory -WinSCPSession $session -RemoteDirectory "rDir/" -LocalDirectory "C:\lDir" -SyncMode Remote
```


I have included the WinSCPnet.dll in the _NeededAssemblies_ folder.

Check back regularly for updates.


this project is licensed with GNU GENERAL PUBLIC LICENSE.