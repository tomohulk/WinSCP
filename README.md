# WinSCP PowerShell Wrapper

This is still a very very beta version, with limited functionality, i will be developing this extensively.  

currently there are only two functions
```PowerShell
New-WinSCPSession
Get-WinSCPFiles
```

Example:

```PowerShell
New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Get-WinSCPFiles -RemoteFile "./MyRemoteDir/MyFile.txt" -LocalFile "C:\MyLocalDir\MyFile.txt"
```

I have included the WinSCPnet.dll in the _NeededAssemblies_ folder.

Check back for updates.