---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/tomohulk/WinSCP/wiki/New-WinSCPSessionOption
schema: 2.0.0
---

# New-WinSCPSessionOption

## SYNOPSIS
Defines information to allow an automatic connection and authentication of the session.

## SYNTAX

```
New-WinSCPSessionOption [-Credential <PSCredential>] [-FtpMode <FtpMode>] [-FtpSecure <FtpSecure>]
 [-GiveUpSecurityAndAcceptAnyTlsHostCertificate <Boolean>] -HostName <String> [-PortNumber <Int32>]
 [-Protocol <Protocol>] [-SecurePrivateKeyPassphrase <SecureString>] [-SshHostKeyFingerprint <String[]>]
 [-SshHostKeyPolicy <SshHostKeyPolicy>] [-SshPrivateKeyPath <String>] [-TlsClientCertificatePath <String>]
 [-TlsHostCertificateFingerprint <String>] [-Timeout <TimeSpan>] [-WebdavSecure] [-RootPath <String>]
 [-RawSetting <Hashtable>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Defines information to allow an automatic connection and authentication of the session.
Is used with the New-WinSCPSession and Get-WinSCPSshHostKeyFingerprint methods.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> New-WinSCPSessionOption -HostName ftp.tomohulk.github.io


Protocol                                     : Sftp
HostName                                     : ftp.tomohulk.github.io
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
PS C:\> New-WinSCPSessionOption -HostName ftp.tomohulk.github.io -Protocol Sftp -SshHostKeyFingerPrint "ssh-dss 2048 01:aa:23:bb:45:cc:67:dd:89:ee:01:ff:23:aa:45:bb" -Credential (Get-Credential)


Protocol                                     : Sftp
HostName                                     : ftp.tomohulk.github.io
PortNumber                                   : 0
UserName                                     : tomohulk
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

### -Credential
Represents a set of security credentials, such as a user name and a password.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Accepted values: Passive, Active

Required: False
Position: Named
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
Accepted values: None, Implicit, Explicit

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GiveUpSecurityAndAcceptAnyTlsHostCertificate
Give up security and accept any FTPS/WebDAVS server TLS/SSL certificate.
To be used in exceptional situations only, when security is not required.
When set, log files will include warning about insecure connection.
To maintain security, use TlsHostCertificateFingerprint.

```yaml
Type: Boolean
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
Position: Named
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
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Protocol
Protocol to use for the session.
Possible values are Protocol.Sftp (default), Protocol.Scp, Protocol.Ftp, Protocol.Webdav and Protocol.S3.

```yaml
Type: Protocol
Parameter Sets: (All)
Aliases:
Accepted values: Sftp, Scp, Ftp, Webdav, S3

Required: False
Position: Named
Default value: Sftp
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurePrivateKeyPassphrase
Encrypted passphrase for encrypted private keys and client certificates.

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

### -SshHostKeyFingerprint
Fingerprint of SSH server host key (or several alternative fingerprints separated by semicolon).
It makes WinSCP automatically accept host key with the fingerprint.
Mandatory for SFTP/SCP protocol.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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

### -RootPath
WebDAV root path or S3 bucket path. Set, when the HTTP server root or S3 bucket list is not accessible.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SshHostKeyPolicy
SSH host key policy. Use the default SshHostKeyPolicy.Check to verify the host key against SshHostKeyFingerprint. Use SshHostKeyPolicy.GiveUpSecurityAndAcceptAny to give up a security and accept any SSH host key. To be used in exceptional situations only, when security is not required. When set, log files will include warning about insecure connection. Use SshHostKeyPolicy.AcceptNew to automatically accept host key of new hosts. The known keys are cached in registry.

```yaml
Type: SshHostKeyPolicy
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### WinSCP.SessionOptions

## NOTES

## RELATED LINKS

[WinSCP reference](https://winscp.net/eng/docs/library_sessionoptions)

