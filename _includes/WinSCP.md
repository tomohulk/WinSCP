# WinSCP PowerShell Module Wrapper

[![Build status](https://ci.appveyor.com/api/projects/status/dgoq6w2xsfh52m6h?svg=true)](https://ci.appveyor.com/project/dotps1/winscp)

## Use at your own risk.

This module can be installed from the [PowerShellGet Gallery](https://www.powershellgallery.com/packages/WinSCP/),  You need [WMF 5](https://www.microsoft.com/en-us/download/details.aspx?id=44987) to use this feature.

```PowerShell
# Inspect
Save-Module -Name WinSCP -Path <Path>

# Install
Install-Module -Name WinSCP
```

## WinSCP Cmdlets

* [ConvertTo-WinSCPEscapedString](https://github.com/dotps1/WinSCP/wiki/ConvertTo-WinSCPEscapedString)
* [Get-WinSCPChildItem](https://github.com/dotps1/WinSCP/wiki/Get-WinSCPChildItem)
* [Get-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Get-WinSCPItem)
* [Get-WinSCPFileChecksum](https://github.com/dotps1/WinSCP/wiki/Get-WinSCPFileChecksum)
* [Invoke-WinSCPCommand](https://github.com/dotps1/WinSCP/wiki/Invoke-WinSCPCommand)
* [Move-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/Move-WinSCPItem)
* [New-WinSCPItem](https://github.com/dotps1/WinSCP/wiki/New-WinSCPItem)
* [New-WinSCPItemPermission](https://github.com/dotps1/WinSCP/wiki/New-WinSCPItemPermission)
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
# Capture credentials.
$credential = Get-Credential

# Create new WinSCP session using captured credentials.
# New-WinSCPSession sets the PSDefaultParameterValue of the WinSCPSession parameter for all other cmdlets to this WinSCP.Session object.
# You can set it to a variable if you would like, but it is only necassary if you will have more then one session open at a time.
New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp

# Use that session to create a new Directory.
New-WinSCPItem -Path './remoteDirectory' -ItemType Directory

# Upload a file to the directory.
Send-WinSCPItem -Path 'C:\localDirectory\localFile.txt' -Destination '/remoteDirectory/'

# Close the session object.
Remove-WinSCPSession
```

Example 2:

```PowerShell
# Create session, download a file, and close the session in one line.
# If the WinSCP.Session Object is passed through the pipeline it will be auto-closed upon the completion of that command.
New-WinSCPSession -Credential (Get-Credential) -HostName $env:COMPUTERNAME -Protocol Ftp | Receive-WinSCPItem -Path './file.txt' -Destination 'C:\folder\'
```

This is still a beta version, with most of the functionality available with WinSCP, I intend on developing this extensively.  

Check back regularly for updates.


This project is licensed with GNU GENERAL PUBLIC LICENSE.