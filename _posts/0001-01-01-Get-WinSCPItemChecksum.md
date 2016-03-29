---
layout: post
title: "Get-WinSCPItemChecksum"
synopsis: "Calculates a checksum of a remote object."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Get-WinSCPItemChecksum [-WinSCPSession] <Session> [-Algorithm] <String> [-Path] <String[]> [<CommonParameters>]
```

---

#### **Description**

Use IANA Algorithm to retrieve the checksum of a remote file.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
* Accept Wildcard Characters: False

[Algorithm \<String\>](http://winscp.net/eng/docs/library_session_calculatefilechecksum)

A name of a checksum algorithm to use. Use IANA name of algorithm or use a name of any proprietary algorithm the server supports (with SFTP protocol only). Commonly supported algorithms are sha-1 and md5.

* Required: True
* Position: 1
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Path \<String\[\]\>](http://winscp.net/eng/docs/library_session_getfileinfo)

A full path to a remote object to calculate a checksum for.

* Required: True
* Position: 2
* Default Value:
* Accept Pipeline Input: True (ByPropertyName)
* Accept Wildcard Characters: False

[CommonParameters \<CommonParameters\>](http://go.microsoft.com/fwlink/?LinkID=113216)

This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.

---

#### **Inputs**

[WinSCP.Session](http://winscp.net/eng/docs/library_session)

* Represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

[String](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

* Represents text as a series of Unicode characters.

---

#### **Outputs**

[System.Array](https://msdn.microsoft.com/en-us/library/system.array(v=vs.110).aspx)

* Provides methods for creating, manipulating, searching, and sorting arrays, thereby serving as the base class for all arrays in the common language runtime.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.
Note that calculation of remote file checksum is supported with SFTP and FTP protocols only, subject to support of [respective protocol extension](http://winscp.net/eng/docs/protocols). 

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -Hostname 'myftphost.org' -Protocol Ftp | Get-WinSCPItemChecksum -Algorithm 'sha-1' -Path '/rDir/file.txt'
```