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

* [ConvertTo-WinSCPEscapedString](http://dotps1.github.io/WinSCP/ConvertTo-WinSCPEscapedString.html)
* [Get-WinSCPChildItem](http://dotps1.github.io/WinSCP/Get-WinSCPChildItem.html)
* [Get-WinSCPItem](http://dotps1.github.io/WinSCP/Get-WinSCPItem.html)
* [Get-WinSCPFileChecksum](http://dotps1.github.io/WinSCP/Get-WinSCPItemChecksum.html)
* [Invoke-WinSCPCommand](http://dotps1.github.io/WinSCP/Invoke-WinSCPCommand.html)
* [Move-WinSCPItem](http://dotps1.github.io/WinSCP/Move-WinSCPItem.html)
* [New-WinSCPItem](http://dotps1.github.io/WinSCP/New-WinSCPItem.html)
* [New-WinSCPItemPermission]http://dotps1.github.io/WinSCP/New-WinSCPItemPermission.html)
* [New-WinSCPSession](http://dotps1.github.io/WinSCP/New-WinSCPSession.html)
* [New-WinSCPTransferOption](http://dotps1.github.io/WinSCP/New-WinSCPTransferOption.html)
* [Receive-WinSCPItem](http://dotps1.github.io/WinSCP/Receive-WinSCPItem.html)
* [Remove-WinSCPItem](http://dotps1.github.io/WinSCP/Remove-WinSCPItem.html)
* [Remove-WinSCPSession](http://dotps1.github.io/WinSCP/Remove-WinSCPSession.html)
* [Rename-WinSCPItem](http://dotps1.github.io/WinSCP/Rename-WinSCPItem.html)
* [Send-WinSCPItem](http://dotps1.github.io/WinSCP/Send-WinSCPItem.html)
* [Start-WinSCPConsole](http://dotps1.github.io/WinSCP/Start-WinSCPConsole.html)
* [Sync-WinSCPPath](http://dotps1.github.io/WinSCP/Sync-WinSCPPath.html)
* [Test-WinSCPPath](http://dotps1.github.io/WinSCP/Test-WinSCPPath.html)


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
