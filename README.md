# WinSCP PowerShell Wrapper

You can install this module with [PsGet](http://psget.net/), if you don't have PsGet, I highly recommend you get it!
```PowerShell
# Install PsGet
(New-Object -TypeName Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression
```

```PowerShell
# Install WinSCP module with PsGet
Install-Module -ModuleUrl "https://github.com/dotps1/WinSCP/raw/master/WinSCP.zip" -ModuleName WinSCP -Type ZIP
```

## WinSCP Cmdlets

* [New-WinSCPSessionOptions](https://github.com/dotps1/WinSCP/wiki/New-WinSCPSessionOptions)
* [Open-WinSCPSession](https://github.com/dotps1/WinSCP/wiki/Open-WinSCPSession)
* [Close-WinSCPSession](https://github.com/dotps1/WinSCP/wiki/Close-WinSCPSession)
* [Receive-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Receive-WinSCPItem)
* [Send-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Send-WinSCPItem)
* [New-WinSCPDirectory](https://github.com/dotps1/WinSCP/wiki/New-WinSCPDirectory)
* [Test-WinSCPItemExists](https://github.com/dotps1/WinSCP/wiki/Test-WinSCPItemExists)
* [Get-WinSCPItemInformation](https://github.com/dotps1/WinSCP/wiki/Get-WinSCPItemInformation)
* [Get-WinSCPDirectoryContents](https://github.com/dotps1/WinSCP/wiki/Get-WinSCPDirectoryContents)
* [Move-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Move-WinSCPItem)
* [Remove-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Remove-WinSCPItem)
* [Sync-WinSCPDirectory](https://github.com/dotps1/WinSCP/wiki/Sync-WinSCPDirectory)
* [ConvertTo-WinSCPEscapedString](https://github.com/dotps1/WinSCP/wiki/ConvertTo-WinSCPEscapedString)
* [New-WinSCPTransferOptions](https://github.com/dotps1/WinSCP/wiki/New-WinSCPTransferOptions)
* [New-WinSCPFilePermissions](https://github.com/dotps1/WinSCP/wiki/New-WinSCPFilePermissions)
* [Invoke-WinSCPCommand](https://github.com/dotps1/WinSCP/wiki/Invoke-WinSCPCommand)


## Examples

Example 1:

```PowerShell
# Splat New-WinSCPSessionOptions.
$sessionOptions = @{
	HostName = "myftphost.org"
	UserName = "ftpuser"
	Password = "FtpUserPword"
	SshHostKeyFingerprint = "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
	}

# Open a new WinSCPSession using the splatted parameters.
$session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @sessionOptions)

# Use that session to create a new Directory and then upload a file to it.
New-WinSCPDirectory -WinSCPSession $session -Path "./remoteDirectory"
Send-WinSCPItem -WinSCPSession $session -LocalPath "C:\localDirectory\localFile.txt" -RemotePath "./remoteDirectory/"

# Close the session.
Close-WinSCPSession -WinSCPSession $session
```

Example 2:
```PowerShell
# Create session and download file in one line.
# If the WinSCPSession object is piped into the another command, it will auto close the session after the command completes.
Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -HostName "myftphost.org" -UserName "ftpUser" -Password "MyPassword" -Protocol Ftp) | Receive-WinSCPItem -RemotePath "./file.txt" -LocalPath "C:\folder\"
```

This is still a very beta version, with most of the functionality available with WinSCP, I intend on developing this extensively.  
I have included the WinSCPnet.dll in the _NeededAssemblies_ folder.

Check back regularly for updates.


this project is licensed with GNU GENERAL PUBLIC LICENSE.