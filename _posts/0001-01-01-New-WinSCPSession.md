---
layout: post
title:  "New-WinSCPSession"
synopsis: "Defines information to allow an automatic connection and authentication of the session."
---

#### **Synopsis**

Defines information to allow an automatic connection and authentication of the session.

---

#### **Syntax**

```powershell
New-WinSCPSession [[-Credential] <PSCredential>] [[-FtpMode] <FtpMode>] [[-FtpSecure] <FtpSecure>] [-GiveUpSecurityAndAcceptAnySshHostKey] [-GiveUpSecureityAndAcceptAnyTlsHostCertificate] [-HostName] <String> [[-PortNumber] <Int32>] [[-Protocol] <Protocol>] [[-SshHostKeyFingerprint] <String[]>] [[-SshPrivateKeyPath] <String>] [[-SshPrivateKeySecurePassphrase] <SecureString>] [[-TlsHostCertificateFingerprint] <String>] [[-Timeout] <TimeSpan>] [-WebdavSecure] [[-WebdavRoot] <String>] [[-RawSetting] <Hashtable>] [[-DebugLogPath] <String>] [[-SessionLogPath] <String>] [[-ReconnectTime] <TimeSpan>] [[-FileTransferProgress] <ScriptBlock>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

---

#### **Description**

Defines all settings that can be configured for the [WinSCP.SessionOptions](http://winscp.net/eng/docs/library_sessionoptions) Object, then opens and returns the [WinSCP.Session](http://winscp.net/eng/docs/library_session) Object.

---

#### **Parameters**

[Credential \<PSCredential\>](https://msdn.microsoft.com/en-us/library/system.management.automation.pscredential(v=vs.85).aspx)

PSCredential object used for authentication.

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline input: True (ByValue)
* Accept Wildcard Characters: False


[FtpMode \<WinSCP.FtpMode\>](http://winscp.net/eng/docs/ftp_modes)

Possible values are FtpMode.Passive (default) and FtpMode.Active.

* Required: False
* Position: 1
* Default Value: \[WinSCP.FtpMode\]::Passive
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[FtpSecure \<WinSCP.FtpSecure\>](http://winscp.net/eng/docs/ftps#methods)

FTPS mode. Possible values are FtpSecure.None (default), FtpSecure.Implicit and FtpSecure.Explicit (FtpSecure.ExplicitTls in older versions).

* Required: False
* Position: 2
* Default Value: \[WinSCP.FtpSecure\]::None
* Accept Pipeline Inupt: False
* Accept Wildcard Characters: False


[GiveUpSecurityAndAcceptAnySshHostKey \<SwitchParameter\>](http://winscp.net/eng/docs/library_sessionoptions)

Give up security and accept any FTPS/WebDAVS server TLS/SSL certificate. To be used in exceptional situations only, when security is not required. When set, log files will include warning about insecure connection. To maintain security, use TlsHostCertificateFingerprint.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[GiveUpSecureityAndAcceptAnyTlsHostCertificate \<SwitchParameter\>](http://winscp.net/eng/docs/library_sessionoptions)

Give up security and accept any FTPS/WebDAVS server TLS/SSL certificate. To be used in exceptional situations only, when security is not required. When set, log files will include warning about insecure connection. To maintain security, use TlsHostCertificateFingerprint.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[HostName \<String\>](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

Name of the host to connect to. Mandatory property.

* Required: True
* Position: 3
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[PortNumber \<Int32\>](https://msdn.microsoft.com/en-us/library/system.int32(v=vs.110).aspx)

Port number to connect to. Keep default 0 to use the default port for the protocol.

* Required: False
* Position: 4
* Default Value: 0
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[Protocol \<WinSCP.Protocol\>](http://winscp.net/eng/docs/library_sessionoptions)

Protocol to use for the session. Possible values are Protocol.Sftp (default), Protocol.Scp, Protocol.Ftp and Protocol.Webdav.
 
* Required: False
* Position: 5
* Default Value: \[WinSCP.Protocol\]::Sftp
* Accept Pipeline Input: False
* Accept Wildcard Characters: False
 
 
[SshHostKeyFingerprint \<String\[\]\>](http://winscp.net/eng/docs/ssh_verifying_the_host_key)
 
Fingerprint of SSH server host key (or several alternative fingerprints separated by semicolon). It makes WinSCP automatically accept host key with the fingerprint. Mandatory for SFTP/SCP protocol.1) Learn how to obtain host key fingerprint. 
 
* Required: False (Mandatory with Sftp and Scp protocols only)
* Position: 6
* Default Value:
* Accept Pipeline Input: True (ByPropertyName)
* Accept Wildcard Characters: False
 
  
[SshPrivateKeyPath \<String\>](http://winscp.net/eng/docs/public_key#private)
 
Full path to private key file.
 
* Required: False
* Position: 7
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False
 
 
[SshPrivateKeySecurePassphrase \<SecureString\>](https://msdn.microsoft.com/en-us/library/system.security.securestring(v=vs.110).aspx)
 
Passphrase for encrypted private keys.
 
* Required: False
* Position: 8
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False
 
 
[TlsHostCertificateFingerprint \<String\>](http://winscp.net/eng/docs/tls#certificate)
 
Fingerprint of FTPS/WebDAVS server TLS/SSL certificate to be automatically accepted (useful for certificates signed by untrusted authority).
 
* Required: False
* Position: 9
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False
 
 
[Timeout \<TimeSpan\>](https://msdn.microsoft.com/en-us/library/system.timespan(v=vs.110).aspx)

Server response timeout. Defaults to 15 seconds.
 
* Required: False
* Position: 10
* Default Value: 15 Seconds
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[WebdavSecure \<SwitchParameter\>](http://winscp.net/eng/docs/library_sessionoptions)

Use WebDAVS (WebDAV over TLS/SSL), instead of WebDAV.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[WebdavRoot \<String\>](http://winscp.net/eng/docs/library_sessionoptions)

WebDAV root path.

* Required: False
* Position: 11
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[RawSetting \<HashTable\>](http://winscp.net/eng/docs/library_sessionoptions_addrawsettings)

A Hashtable of Settings and Values to add to the WinSCP.SessionOptions Object.

* Required: False
* Position: 12
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[DebugLogPath \<String\>](http://winscp.net/eng/docs/library_session)

Path to store assembly debug log to. Default null means, no debug log file is created. See also SessionLogPath.

* Required: False
* Position: 13
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[SessionLogPath \<String\>](http://winscp.net/eng/docs/library_session)

Path to store session log file to. Default null means, no session log file is created.

* Required: False
* Position: 14
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[ReconnectTime \<TimeSpan\>](https://social.msdn.microsoft.com/Search/en-US?query=TimeSpan&pgArea=header&emptyWatermark=true&ac=4)

Sets time limit in seconds to try reconnecting broken sessions. Default is 120 seconds. Use TimeSpan.MaxValue to remove any limit.

* Required: False
* Position: 15
* Default Value: 120 Seconds
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[FileTransferProgress \<ScriptBlock\>](https://msdn.microsoft.com/en-us/library/system.management.automation.scriptblock(v=vs.85).aspx)

Adds the ability to run a script block for each file transfer.  Use this for progress bar control.

* Required: False
* Position: 16
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[CommonParameters \<CommonParameters\>](http://go.microsoft.com/fwlink/?LinkID=113216)

This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.

---

#### **Inputs**

[System.Management.Automation.PSCredential](https://msdn.microsoft.com/en-us/library/system.management.automation.pscredential(v=vs.85).aspx)

* Represents a set of security credentials, such as a user name and a password.


[System.String](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

* Represents text as a series of Unicode characters.

---

#### **Outputs**

[WinSCP.Session](http://winscp.net/eng/docs/library_session)

* Represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

---

#### **Notes**

This function is used to open a WinSCP Session to be used with most other cmdlets in the WinSCP PowerShell Module.

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -HostName $env:COMPUTERNAME -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -Protocol Ftp

ExecutablePath                : 
AdditionalExecutableArguments : 
DefaultConfiguration          : True
DisableVersionCheck           : False
IniFilePath                   : 
ReconnectTime                 : 00:02:00
ReconnectTimeInMilliseconds   : 120000
DebugLogPath                  : 
DebugLogLevel                 : 0
SessionLogPath                : 
XmlLogPath                    : C:\Users\$env:USERNAME\AppData\Local\Temp\wscp6934.0246B60F.tmp
HomePath                      : /
Timeout                       : 00:01:00
Output                        : {winscp> option batch on, batch on, reconnecttime 120, winscp>...}
Opened                        : True
UnderlyingSystemType          : WinSCP.Session
```