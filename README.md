# WinSCP PowerShell Module Wrapper
[![CI/CD](https://github.com/tomohulk/WinSCP/actions/workflows/Build.yml/badge.svg)](https://github.com/tomohulk/WinSCP/actions/workflows/Build.yml)

## Use at your own risk.

This module can be installed from the [PowerShellGet Gallery](https://www.powershellgallery.com/packages/WinSCP/),  You need [WMF 5](https://aka.ms/wmf5download) to use this feature.
```PowerShell
# Inspect
Save-Module -Name WinSCP -Path <Path>

# Install
Install-Module -Name WinSCP
```

## WinSCP Cmdlets

* [ConvertTo-WinSCPEscapedString](https://github.com/tomohulk/WinSCP/wiki/ConvertTo-WinSCPEscapedString)
* [Copy-WInSCPItem](https://github.com/tomohulk/WinSCP/wiki/Copy-WinSCPItem)
* [Get-WinSCPChildItem](https://github.com/tomohulk/WinSCP/wiki/Get-WinSCPChildItem)
* [Get-WinSCPItem](https://github.com/tomohulk/WinSCP/wiki/Get-WinSCPItem)
* [Get-WinSCPFileChecksum](https://github.com/tomohulk/WinSCP/wiki/Get-WinSCPItemChecksum)
* [Get-WinSCPSession](https://github.com/tomohulk/WinSCP/wiki/Get-WinSCPSession)
* [Get-WinSCPSshHostKeyFingerprint](https://github.com/tomohulk/WinSCP/wiki/Get-WinSCPSshHostKeyFingerprint)
* [Invoke-WinSCPCommand](https://github.com/tomohulk/WinSCP/wiki/Invoke-WinSCPCommand)
* [Move-WinSCPItem](https://github.com/tomohulk/WinSCP/wiki/Move-WinSCPItem)
* [New-WinSCPItem](https://github.com/tomohulk/WinSCP/wiki/New-WinSCPItem)
* [New-WinSCPItemPermission](https://github.com/tomohulk/WinSCP/wiki/New-WinSCPItemPermission)
* [New-WinSCPSession](https://github.com/tomohulk/WinSCP/wiki/New-WinSCPSession)
* [New-WinSCPSessionOption](https://github.com/tomohulk/WinSCP/wiki/New-WinSCPSessionOption)
* [New-WinSCPTransferOption](https://github.com/tomohulk/WinSCP/wiki/New-WinSCPTransferOption)
* [New-WinSCPTransferResumeSupport](https://github.com/tomohulk/WinSCP/wiki/New-WinSCPTransferResumeSupport)
* [Receive-WinSCPItem](https://github.com/tomohulk/WinSCP/wiki/Receive-WinSCPItem)
* [Remove-WinSCPItem](https://github.com/tomohulk/WinSCP/wiki/Remove-WinSCPItem)
* [Remove-WinSCPSession](https://github.com/tomohulk/WinSCP/wiki/Remove-WinSCPSession)
* [Rename-WinSCPItem](https://github.com/tomohulk/WinSCP/wiki/Rename-WinSCPItem)
* [Send-WinSCPItem](https://github.com/tomohulk/WinSCP/wiki/Send-WinSCPItem)
* [Start-WinSCPConsole](https://github.com/tomohulk/WinSCP/wiki/Start-WinSCPConsole)
* [Sync-WinSCPPath](https://github.com/tomohulk/WinSCP/wiki/Sync-WinSCPPath)
* [Test-WinSCPPath](https://github.com/tomohulk/WinSCP/wiki/Test-WinSCPPath)


## Example

```PowerShell
# Capture credentials.
$credential = Get-Credential

# Set the options to open the WinSCPSession with
$sessionOption = New-WinSCPSessionOption -HostName ftp.tomohulk.github.io -Protocol Ftp -Credential $credential

# Open the session using the SessionOptions object.
# New-WinSCPSession sets the PSDefaultParameterValue of the WinSCPSession parameter for all other cmdlets to this WinSCP.Session object.
# You can set it to a variable if you would like, but it is only necessary if you will have more then one session open at a time.
New-WinSCPSession -SessionOption $sessionOption

# Use that session to create a new Directory.
New-WinSCPItem -Path './remoteDirectory' -ItemType Directory

# Upload a file to the directory.
Send-WinSCPItem -Path 'C:\localDirectory\localFile.txt' -Destination '/remoteDirectory/'

# Close and remove the session object.
Remove-WinSCPSession
```


Check back regularly for updates.


This project is licensed with GNU GENERAL PUBLIC LICENSE.
