---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/Get-WinSCPServerPublicKeyFingerprint
schema: 2.0.0
---

# Get-WinSCPHostKeyFingerprint

## SYNOPSIS
Scans a fingerprint of SSH server public key (host key) or FTPS/WebDAVS TLS certificate.

## SYNTAX

```
Get-WinSCPHostKeyFingerprint -SessionOption <SessionOptions[]> -Algorithm <String> [<CommonParameters>]
```

## DESCRIPTION
Scans a fingerprint of SSH server public key (host key) or FTPS/WebDAVS TLS certificate.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> $sessionOption = New-WinSCPSessionOption -HostName ftp.dotps1.github.io
PS C:\> $sshHostKeyFingerprint = Get-WinSCPHostKeyFingerprint -SessionOption $sessionOption
PS C:\> $sessionOption.SshHostKeyFingerprint = $sshHostKeyFingerprint
PS C:\> New-WinSCPSession -SessionOption $sessionOption


Opened       Timeout HostName
------       ------- --------
True        00:01:00 ftp.dotps1.github.io


PS C:\> Remove-WinSCPSession
```

### EXAMPLE 2
```
PS C:\> $sessionOption = New-WinSCPSessionOption -HostName ftp.dotps1.github.io -FtpSecure Implicit -Port 990 -Protocol Ftp -TlsClientCertificatePath C:\ftp.dotps1.github.io.crt
PS C:\> $tlsHostCertificateFingerprint = Get-WinSCPHostFingerprint -SessionOptions $sessionOption -Algorithm MD5
PS C:\> $sessionOption.TlsHostCertificateFingerprint = $tlsHostCertificateFingerprint
PS C:\> New-WinSCPSession -SessionOption $sessionOption


Opened       Timeout HostName
------       ------- --------
True        00:01:00 ftp.dotps1.github.io


PS C:\> Remove-WinSCPSession
```

## PARAMETERS

### -SessionOption
Defines a server to scan the fingerprint of.
The Protocol property must be Protocol.Sftp or Protocol.Scp, or Protocol.Ftp with FtpSecure being FtpSecure.Implicit or FtpSecure.Explicit, or Protocol.Webdav with WebdavSecure being true.
Other than that only the HostName needs to be set.
The PortNumber, Timeout and few raw session settings can be set, if necessary.
The other properties are ignored.

```yaml
Type: SessionOptions[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Algorithm
Fingerprint algorithm to use.
Supported algorithms are SHA-256 (recommended with SFTP and SCP protocols) and MD5 (the only supported option with FTPS and WebDAVS.
With SFTP and SCP protocols, it should be used only for backward compatibility with previous versions).
This parameter is present since version 5.13 only.
Older versions lack the parameter and use MD5 algorithm.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: SHA-256
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### WinSCP.SessionOptions[]

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

[WinSCP reference:](https://winscp.net/eng/docs/library_session_scanfingerprint)

