# WinSCP PowerShell Module Wrapper

This module can be installed from the [PowerShellGet Gallery](https://www.powershellgallery.com/packages/WinSCP/),  You need [WMF 5](https://www.microsoft.com/en-us/download/details.aspx?id=44987) to use this feature.
```PowerShell
# To install WinSCP, run the following command in the PowerShell prompt in Administrator mode:
Install-Module -Name WinSCP
```

I will no longer be supporting Chocolatey or PSGet for module repos; mainly because i feel the PowerShellGallery is working very well, and Chocolatey takes months to approve packages.  I apologize for any trouble this causes.

## WinSCP Cmdlets

* [ConvertTo-WinSCPEscapedString](https://github.com/dotps1/WinSCP/wiki/ConvertTo-WinSCPEscapedString)
* [Get-WinSCPChildItem](https://github.com/dotps1/WinSCP/wiki/Get-WinSCPChildItem)
* [Get-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Get-WinSCPItem)
* [Get-WinSCPFileChecksum](https://github.com/dotps1/WinSCP/wiki/Get-WinSCPFileChecksum)
* [Invoke-WinSCPCommand](https://github.com/dotps1/WinSCP/wiki/Invoke-WinSCPCommand)
* [Move-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Move-WinSCPItem)
* [New-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/New-WinSCPItem)
* [New-WinSCPFilePermission](https://github.com/dotps1/WinSCP/wiki/New-WinSCPFilePermission)
* [New-WinSCPSession](https://github.com/dotps1/WinSCP/wiki/New-WinSCPSession)
* [New-WinSCPTransferOption](https://github.com/dotps1/WinSCP/wiki/New-WinSCPTransferOption)
* [Receive-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Receive-WinSCPItem)
* [Remove-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Remove-WinSCPItem)
* [Remove-WinSCPSession](https://github.com/dotps1/WinSCP/wiki/Remove-WinSCPSession)
* [Rename-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Rename-WinSCPItem)
* [Send-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Send-WinSCPItem)
* [Start-WinSCPConsole](https://github.com/dotps1/WinSCP/wiki/Start-WinSCPConsole)
* [Sync-WinSCPPath](https://github.com/dotps1/WinSCP/wiki/Sync-WinSCPPath)
* [Test-WinSCPPath](https://github.com/dotps1/WinSCP/wiki/Test-WinSCPPath)


## Examples

Example 1:

```PowerShell
# Open a new WinSCPSession using the splatted parameters.
$credential = Get-Credential
$session = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp

# Use that session to create a new Directory and then upload a file to it.
New-WinSCPItem -WinSCPSession $session -Path './remoteDirectory' -ItemType Directory
Send-WinSCPItem -WinSCPSession $session -LocalPath "C:\localDirectory\localFile.txt" -RemotePath "./remoteDirectory/"

# Close the session object.
Remove-WinSCPSession -WinSCPSession $session
```

Example 2:
```PowerShell
# Create session, download a file, and close the session in one line.
# If the WinSCP.Session Object is passed through the pipeline it will be auto-closed upon the completion of that command.
# To avoid this behaviour, set the WinSCP.Session object value to variable to be reused.
New-WinSCPSession -Credential (Get-Credential) -HostName $env:COMPUTERNAME -Protocol Ftp | Receive-WinSCPItem -RemotePath "./file.txt" -LocalPath "C:\folder\"
```

This is still a very beta version, with most of the functionality available with WinSCP, I intend on developing this extensively.  
I have included the WinSCPnet.dll in the _NeededAssemblies_ folder.

Check back regularly for updates.


this project is licensed with GNU GENERAL PUBLIC LICENSE.