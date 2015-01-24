# WinSCP PowerShell Wrapper

This is still a very beta version, with most of the functionality available with WinSCP, I intend on developing this extensively.  

Current avaialbe functions:
```PowerShell
New-WinSCPSessionOptions
Open-WinSCPSession
Close-WinSCPSession
Receive-WinSCPItem
Send-WinSCPItem
New-WinSCPDirectory
Test-WinSCPItemExsits
Get-WinSCPItemInformation
Get-WinSCPDirectoryContents
Move-WinSCPItem
Remove-WinSCPItem
Sync-WinSCPDirectory
ConvertTo-WinSCPEscapedString
New-WinSCPTransferOptions
New-WinSCPFilePermmissions
Invoke-WinSCPCommand
```

Example 1:

```PowerShell
PS C:\> $session = New-WinSCPSessionOptions -Hostname "myftphost.org" -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
PS C:\> Send-WinSCPItem -WinSCPSession $session -LocalPath "C:\lDir\lFile.txt" -RemotePath "rDir/rFile.txt" -RemoveLocalItem
```

Example 2:

```PowerShell
PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname "myftphost.org" -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Send-WinSCPItem -LocalPath "C:\lDir\lFile.txt" -RemotePath "rDir/rFile.txt" 
```

Example 3:

```PowerShell
$session = New-WinSCPSessionOptions -Hostname "myftphost.org" -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
Receive-WinSCPItem -WinSCPSession $session -RemotePath "rDir/rFile.txt" -LocalPath "C:\lDir\lFile.txt" -RemoveRemoteItem
```

Example 4:

```PowerShell
$session = New-WinSCPSessionOptions -Hostname "myftphost.org" -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
Sync-WinSCPDirectory -WinSCPSession $session -RemotePath "rDir/" -LocalPath "C:\lDir" -SyncMode Remote
```


I have included the WinSCPnet.dll in the _NeededAssemblies_ folder.

Check back regularly for updates.


this project is licensed with GNU GENERAL PUBLIC LICENSE.