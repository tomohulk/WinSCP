﻿# Get-WinSCPSshHostKeyFingerprint

## SYNOPSIS
Scans a fingerprint of SSH server public key (host key) or FTPS/WebDAVS TLS certificate.

## SYNTAX

### Set 1
```
Get-WinSCPSshHostKeyFingerprint [-SessionOption] <SessionOptions[]> [<CommonParameters>]
```

## DESCRIPTION
Scans a fingerprint of SSH server public key (host key) or FTPS/WebDAVS TLS certificate.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> $sessionOption = New-WinSCPSessionOption -HostName ftp.dotps1.github.io
PS C:\> Get-WinSCPSshHostKeyFingerprint -SessionOption $sessionOption
ssh-dss 2048 01:aa:23:bb:45:cc:67:dd:89:ee:01:ff:23:aa:45:bb
```

### EXAMPLE 2

```powershell
PS C:\> $sessionOption = New-WinSCPSessionOption -HostName ftp.dotps1.github.io
PS C:\> $sshHostKeyFingerprint = Get-WinSCPSshHostKeyFingerprint -SessionOption $sessionOption
PS C:\> $sessionOption.SshHostKeyFingerprint = $sshHostKeyFingerprint
PS C:\> New-WinSCPSession -SessionOption $sessionOption


Opened       Timeout HostName
------       ------- --------
True        00:01:00 ftp.dotps1.github.io


PS C:\> Remove-WinSCPSession
```

## PARAMETERS

### SessionOption
Defines a server to scan the fingerprint of.
The Protocol property must be Protocol.Sftp or Protocol.Scp, or Protocol.Ftp with FtpSecure being FtpSecure.Implicit or FtpSecure.Explicit, or Protocol.Webdav with WebdavSecure being true. Other than that only the HostName needs to be set. The PortNumber, Timeout and few raw session settings can be set, if necessary. The other properties are ignored.

```yaml
Type: SessionOptions[]
Parameter Sets: Set 1
Aliases: 

Required: true
Position: 0
Default Value: 
Pipeline Input: True (ByPropertyName, ByValue)
```

### \<CommonParameters\>
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### WinSCP.SessionOptions[]


## OUTPUTS

### System.String


## NOTES

## RELATED LINKS

[Online version:](https://dotps1.github.io/WinSCP/Get-WinSCPSshServerPublicKeyFingerprint.html)

[WinSCP reference:](https://winscp.net/eng/docs/library_session_scanfingerprint)


*Generated by:  PowerShell HelpWriter 2017 v2.1.35*