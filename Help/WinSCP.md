---
Module Name: WinSCP
Module Guid: 06e0af4e-779b-48f4-939f-c90b8ec950e6
Download Help Link: https://github.com/dotps1/winscp/wiki.git
Help Version: 5.13.1
Locale: en-US
---

# WinSCP Module
## Description
This is a PowerShell module designed to wrapper the open source WinSCP .net library.
The goal of this project was to create a feeling of using native PowerShell commands with WinSCP.

## WinSCP Cmdlets
### [ConvertTo-WinSCPEscapedString](ConvertTo-WinSCPEscapedString.md)
Converts special characters in file path to make it unambiguous file mask/wildcard.

### [Copy-WinSCPItem](Copy-WinSCPItem.md)
Duplicates remote file to another remote directory or name.

### [Get-WinSCPChildItem](Get-WinSCPChildItem.md)
Recursively enumerates remote files.

### [Get-WinSCPHostKeyFingerprint](Get-WinSCPHostKeyFingerprint.md)
Scans a fingerprint of SSH server public key (host key) or FTPS/WebDAVS TLS certificate.

### [Get-WinSCPItem](Get-WinSCPItem.md)
Recursively enumerates remote files.

### [Get-WinSCPItemChecksum](Get-WinSCPItemChecksum.md)
Calculates a checksum of a remote file.

### [Get-WinSCPSession](Get-WinSCPSession.md)
Gets a WinSCP.Session object.

### [Invoke-WinSCPCommand](Invoke-WinSCPCommand.md)
Executes command on the remote server.

### [Move-WinSCPItem](Move-WinSCPItem.md)
Moves remote file to another remote directory and/or renames remote file.

### [New-WinSCPItem](New-WinSCPItem.md)
Creates a new item on a remote system.

### [New-WinSCPItemPermission](New-WinSCPItemPermission.md)
Represents *nix-style remote file permissions.

### [New-WinSCPSession](New-WinSCPSession.md)
This is the main interface class of the WinSCP assembly.

### [New-WinSCPSessionOption](New-WinSCPSessionOption.md)
Defines information to allow an automatic connection and authentication of the session.

### [New-WinSCPTransferOption](New-WinSCPTransferOption.md)
Defines options for file transfers.

### [New-WinSCPTransferResumeSupport](New-WinSCPTransferResumeSupport.md)
Configures automatic resume/transfer to temporary filename.

### [Receive-WinSCPItem](Receive-WinSCPItem.md)
Downloads one or more files from remote directory to local directory.

### [Remove-WinSCPItem](Remove-WinSCPItem.md)
Removes one or more remote files.

### [Remove-WinSCPSession](Remove-WinSCPSession.md)
Closes and disposes the WinSCP.Session object.

### [Rename-WinSCPItem](Rename-WinSCPItem.md)
Moves remote file to another remote directory and/or renames remote file.

### [Send-WinSCPItem](Send-WinSCPItem.md)
Uploads one or more files from local directory to remote directory.

### [Start-WinSCPConsole](Start-WinSCPConsole.md)
Starts an iteractive WinSCP Console.

### [Sync-WinSCPPath](Sync-WinSCPPath.md)
Synchronizes directories.

### [Test-WinSCPPath](Test-WinSCPPath.md)
Checks for existence of remote file or directory.
