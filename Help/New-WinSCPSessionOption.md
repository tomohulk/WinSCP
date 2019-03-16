---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/New-WinSCPSessionOption
schema: 2.0.0
---

# New-WinSCPSessionOption

## SYNOPSIS
Defines information to allow an automatic connection and authentication of the session.

## SYNTAX

```
New-WinSCPSessionOption [[-Credential] <PSCredential>] [[-FtpMode] <FtpMode>] [[-FtpSecure] <FtpSecure>]
 [-GiveUpSecurityAndAcceptAnySshHostKey] [-GiveUpSecurityAndAcceptAnyTlsHostCertificate] [-HostName] <String>
 [[-PortNumber] <Int32>] [[-Protocol] <Protocol>] [-SecurePrivateKeyPassphrase <SecureString>]
 [[-SshHostKeyFingerprint] <String[]>] [[-SshPrivateKeyPath] <String>] [[-TlsClientCertificatePath] <String>]
 [[-TlsHostCertificateFingerprint] <String>] [[-Timeout] <TimeSpan>] [-WebdavSecure] [[-WebdavRoot] <String>]
 [[-RawSetting] <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Defines information to allow an automatic connection and authentication of the session.
Is used with the New-WinSCPSession and Get-WinSCPSshHostKeyFingerprint methods.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> New-WinSCPSessionOption -HostName ftp.dotps1.github.io


Protocol                                     : Sftp
HostName                                     : ftp.dotps1.github.io
PortNumber                                   : 0
UserName                                     : anonymous
Password                                     :
SecurePassword                               : System.Security.SecureString
NewPassword                                  :
SecureNewPassword                            :
Timeout                                      : 00:00:15
TimeoutInMilliseconds                        : 15000
PrivateKeyPassphrase                         :
SshHostKeyFingerprint                        :
GiveUpSecurityAndAcceptAnySshHostKey         : False
SshPrivateKeyPath                            :
SshPrivateKeyPassphrase                      :
FtpMode                                      : Passive
FtpSecure                                    : None
WebdavSecure                                 : False
WebdavRoot                                   :
TlsHostCertificateFingerprint                :
GiveUpSecurityAndAcceptAnyTlsHostCertificate : False
TlsClientCertificatePath                     :
```

### EXAMPLE 2
```
PS C:\> New-WinSCPSessionOption -HostName ftp.dotps1.github.io -Protocol Sftp -SshHostKeyFingerPrint "ssh-dss 2048 01:aa:23:bb:45:cc:67:dd:89:ee:01:ff:23:aa:45:bb" -Credential (Get-Credential)


Protocol                                     : Sftp
HostName                                     : ftp.dotps1.github.io
PortNumber                                   : 0
UserName                                     : dotps1
Password                                     :
SecurePassword                               : System.Security.SecureString
NewPassword                                  :
SecureNewPassword                            :
Timeout                                      : 00:00:15
TimeoutInMilliseconds                        : 15000
PrivateKeyPassphrase                         :
SshHostKeyFingerprint                        : ssh-dss 2048 01:aa:23:bb:45:cc:67:dd:89:ee:01:ff:23:aa:45:bb
GiveUpSecurityAndAcceptAnySshHostKey         : False
SshPrivateKeyPath                            :
SshPrivateKeyPassphrase                      :
FtpMode                                      : Passive
FtpSecure                                    : None
WebdavSecure                                 : False
WebdavRoot                                   :
TlsHostCertificateFingerprint                :
GiveUpSecurityAndAcceptAnyTlsHostCertificate : False
TlsClientCertificatePath                     :
```

## PARAMETERS

### -Credential
Represents a set of security credentials, such as a user name and a password.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FtpMode
Possible values are FtpMode.Passive (default) and FtpMode.Active.

```yaml
Type: FtpMode
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FtpSecure
Possible values are FtpSecure.None (default), FtpSecure.Implicit and FtpSecure.Explicit.

```yaml
Type: FtpSecure
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GiveUpSecurityAndAcceptAnySshHostKey
Give up security and accept any SSH host key.
To be used in exceptional situations only, when security is not required.
When set, log files will include warning about insecure connection.
To maintain security, use SshHostKeyFingerprint.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -GiveUpSecurityAndAcceptAnyTlsHostCertificate
Give up security and accept any FTPS/WebDAVS server TLS/SSL certificate.
To be used in exceptional situations only, when security is not required.
When set, log files will include warning about insecure connection.
To maintain security, use TlsHostCertificateFingerprint.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostName
Name of the host to connect to.
Mandatory property.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ComputerName

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortNumber
Port number to connect to.
Keep default 0 to use the default port for the protocol.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Protocol
Protocol to use for the session.
Possible values are Protocol.Sftp (default), Protocol.Scp, Protocol.Ftp and Protocol.Webdav.

```yaml
Type: Protocol
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Sftp
Accept pipeline input: False
Accept wildcard characters: False
```

### -SshHostKeyFingerprint
Fingerprint of SSH server host key (or several alternative fingerprints separated by semicolon).
It makes WinSCP automatically accept host key with the fingerprint.
Mandatory for SFTP/SCP protocol.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SshPrivateKeyPath
Full path to SSH private key file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TlsClientCertificatePath
Full path to TLS/SSL client certificate.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TlsHostCertificateFingerprint
Fingerprint of FTPS/WebDAVS server TLS/SSL certificate to be automatically accepted (useful for certificates signed by untrusted authority).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Server response timeout.
Defaults to 15 seconds.

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebdavSecure
Use WebDAVS (WebDAV over TLS/SSL), instead of WebDAV.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebdavRoot
WebDAV root path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RawSetting
Allows configuring any site settings using raw format as in an INI file.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurePrivateKeyPassphrase
{{Fill SecurePrivateKeyPassphrase Description}}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### WinSCP.SessionOptions

## NOTES

## RELATED LINKS

[WinSCP reference:](https://winscp.net/eng/docs/library_sessionoptions)

