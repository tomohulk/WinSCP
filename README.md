# WinSCP PowerShell Wrapper

This is still a very beta version, with most base functionality available with WinSCP, I intend on developing this extensively.  

Current avaialbe functions:
```PowerShell
Open-WinSCPSession
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
Sync-WinSCPDirectory
Invoke-WinSCPCommands
ConvertTo-WinSCPEscapedString
```

Example 1:

```PowerShell
# Connect to host and download MyFile.txt to the local machine.
# AutoCloses the session upon completion.
Open-WinSCPSession -HostName "myhost.org" -Username "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | 
     Receive-WinSCPItems -RemoteItem "./MyRemoteDir/MyFile.txt" -LocalItem "C:\MyLocalDir\MyFile.txt"
```

Example 2:

```PowerShell
# Connect to the host and upload myfile.txt.
$session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp
Send-WinSCPItem -WinSCPSession $session -LocalItem "C:\Dir\myfile.txt" -Remote-Item "home/dir/myfile.txt"
Close-WinSCPSession -WinSCPSession $session
```

Example 3:

```PowerShell
#Connect to the host and verify the item MyNewDir exists.
$session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp
Test-WinSCPItemExists -WinSCPSession $session -RemoteItem "home/MyDir/MyNewDir"
Close-WinSCPSession -WinSCPSession $session
```

Example 4:

```PowerShell
# Connect to the host and syncronize subdir with SubDir based on file DateTime.
# AutoCloses the session upon completion.
Open-WinSCPSession -HostName "ftp.org" -Protocol Ftp | Sync-WinSCPDirectorys -RemoteDirectory "mydir/subdir" -LocalDirectory "C:\SubDir" -Local -Time
```


I have included the WinSCPnet.dll in the _NeededAssemblies_ folder.

Check back regularly for updates.