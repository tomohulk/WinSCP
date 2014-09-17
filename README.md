# WinSCP PowerShell Wrapper

This is still a very beta version, with some base functionality, I intend on developing this extensively.  

currently there are only a few functions:
```PowerShell
New-WinSCPSession
Test-WinSCPSession
Close-WinSCPSession
Receive-WinSCPItem
Send-WinSCPItem
New-WinSCPDirectory
Test-WinSCPItemExsits
Get-WinSCPItemInformation
Get-WinSCPDirectoryContents
Move-WinSCPItem
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

Example 3:
```PowerShell
$session = New-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Test-WinSCPItemExists -WinSCPSession $session -RemoteItem "home/MyDir/MyNewDir"
```

I have included the WinSCPnet.dll in the _NeededAssemblies_ folder.

Check back regularly for updates.