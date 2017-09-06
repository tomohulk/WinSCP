# New-WinSCPSessionOption

## SYNOPSIS


## SYNTAX

### Set 1
```
New-WinSCPSessionOption [[-Credential] <PSCredential>] [[-FtpMode] <FtpMode>] [[-FtpSecure] <FtpSecure>] [-HostName] <String> [[-PortNumber] <Int32>] [[-PrivateKeyPassphrase] <SecureString>] [[-Protocol] <Protocol>] [[-SshHostKeyFingerprint] <String[]>] [[-SshPrivateKeyPath] <String>] [[-TlsClientCertificatePath] <String>] [[-TlsHostCertificateFingerprint] <String>] [[-Timeout] <TimeSpan>] [[-WebdavRoot] <String>] [[-RawSetting] <Hashtable>] [-GiveUpSecurityAndAcceptAnySshHostKey] [-GiveUpSecurityAndAcceptAnyTlsHostCertificate] [-WebdavSecure] [<CommonParameters>]
```

## DESCRIPTION


## EXAMPLES

### EXAMPLE 1

```powershell
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

```powershell
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

### Credential
Represents a set of security credentials, such as a user name and a password.

```yaml
Type: PSCredential
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 0
Default Value: 
Pipeline Input: false
```

### FtpMode
Possible values are FtpMode.Passive (default) and FtpMode.Active.

```yaml
Type: FtpMode
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 1
Default Value: 
Pipeline Input: false
```

### FtpSecure
Possible values are FtpSecure.None (default), FtpSecure.Implicit and FtpSecure.Explicit.

```yaml
Type: FtpSecure
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 2
Default Value: 
Pipeline Input: false
```

### GiveUpSecurityAndAcceptAnySshHostKey
Give up security and accept any SSH host key. To be used in exceptional situations only, when security is not required. When set, log files will include warning about insecure connection. To maintain security, use SshHostKeyFingerprint.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### GiveUpSecurityAndAcceptAnyTlsHostCertificate
Give up security and accept any FTPS/WebDAVS server TLS/SSL certificate. To be used in exceptional situations only, when security is not required. When set, log files will include warning about insecure connection. To maintain security, use TlsHostCertificateFingerprint.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### HostName
Name of the host to connect to. Mandatory property.

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: true
Position: 3
Default Value: 
Pipeline Input: false
```

### PortNumber
Port number to connect to. Keep default 0 to use the default port for the protocol.

```yaml
Type: Int32
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 4
Default Value: 0
Pipeline Input: false
```

### PrivateKeyPassphrase
Passphrase for encrypted private keys and client certificates.

```yaml
Type: SecureString
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 5
Default Value: 
Pipeline Input: false
```

### Protocol
Protocol to use for the session. Possible values are Protocol.Sftp (default), Protocol.Scp, Protocol.Ftp and Protocol.Webdav.

```yaml
Type: Protocol
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 6
Default Value: Sftp
Pipeline Input: false
```

### SshHostKeyFingerprint
Fingerprint of SSH server host key (or several alternative fingerprints separated by semicolon). It makes WinSCP automatically accept host key with the fingerprint. Mandatory for SFTP/SCP protocol.

```yaml
Type: String[]
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 7
Default Value: 
Pipeline Input: True (ByPropertyName)
```

### SshPrivateKeyPath
Full path to SSH private key file.

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 8
Default Value: 
Pipeline Input: false
```

### TlsClientCertificatePath
Full path to TLS/SSL client certificate.

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 9
Default Value: 
Pipeline Input: false
```

### TlsHostCertificateFingerprint
Fingerprint of FTPS/WebDAVS server TLS/SSL certificate to be automatically accepted (useful for certificates signed by untrusted authority).

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 10
Default Value: 
Pipeline Input: false
```

### Timeout
Server response timeout. Defaults to 15 seconds.

```yaml
Type: TimeSpan
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 11
Default Value: 
Pipeline Input: false
```

### WebdavSecure
Use WebDAVS (WebDAV over TLS/SSL), instead of WebDAV.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### WebdavRoot
WebDAV root path.

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 12
Default Value: 
Pipeline Input: false
```

### RawSetting
Allows configuring any site settings using raw format as in an INI file.

```yaml
Type: Hashtable
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 13
Default Value: 
Pipeline Input: false
```

### \<CommonParameters\>
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]


## OUTPUTS

### WinSCP.SessionOptions


## NOTES

## RELATED LINKS

[Online version:](https://dotps1.github.io/WinSCP/New-WinSCPSessionOption.html)

[WinSCP reference:](https://winscp.net/eng/docs/library_sessionoptions)


*Generated by: PowerShell HelpWriter 2017 v2.1.36*
