# WinSCP PowerShell Wrapper

This is still a very very beta version, with limited functionality, I intend on developing this extensively.  

currently there are only a few functions:
```PowerShell
New-WinSCPSession
Receive-WinSCPItem
Send-WinSCPItem
New-WinSCPDirectory
Get-WinSCPItemInformation
Move-WinSCPItem
Get-WinSCPDirectoryContents
Remove-WinSCPItem
```

Example 1:

```PowerShell
New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Receive-WinSCPItems -RemoteItem "./MyRemoteDir/MyFile.txt" -LocalItem "C:\MyLocalDir\MyFile.txt"
```

Example 2:
```PowerShell
$session = New-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp
Send-WinSCPItem -WinSCPSession $session -LocalItem "C:\Dir\myfile.txt" -Remote-Item "home/dir/myfile.txt"
```

I have included the WinSCPnet.dll in the _NeededAssemblies_ folder.

Check back regularly for updates.