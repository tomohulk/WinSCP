---
layout: post
title:  "Get-WinSCPItem"
synopsis: "Retrieves information about a File or Directory from an active WinSCP Session."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Get-WinSCPItem [-WinSCPSession] <Session> [[-Path] <String[]>] [[-Filter] <String>] [<CommonParameters>]
```

---

#### **Description**

Retrieves Name, FileType, Length, LastWriteTime, FilePermissions, and IsDirectory Properties on an Item from an Active WinSCP Session.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
* Accept Wildcard Characters: False

[Path \<String\[\]\>](http://winscp.net/eng/docs/library_session_getfileinfo)

Specifies a path to one or more locations. Wildcards are permitted. The default location is the home directory of the user making the connection.

* Required: False
* Position: 1
* Default Value:
* Accept Pipeline Input: True (ByPropertyName)
* Accept Wildcard Characters: True

[Filter \<String\>](http://winscp.net/eng/docs/operation_mask)

Filter to be applied to returned objects.

* Required: False
* Position: 2
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: True

[CommonParameters \<CommonParameters\>](http://go.microsoft.com/fwlink/?LinkID=113216)

This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.

---

#### **Inputs**

[WinSCP.Session](http://winscp.net/eng/docs/library_session)

* Represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

[System.String](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

* Represents text as a series of Unicode characters.

---

#### **Ouputs**

[WinSCP.RemoteFileInfo](http://winscp.net/eng/docs/library_remotefileinfo)

* Represents data about remote file.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem -Path '/rDir/rSubDir'

   Directory: /rDir

FileType             LastWriteTime     Length Name
--------             -------------     ------ ----
D             1/1/2015 12:00:00 AM          0 /rdir/rSubDir
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Get-WinSCPItem -WinSCPSession $session -Path '/rDir/rSubDir'

   Directory: /rDir

FileType             LastWriteTime     Length Name
--------             -------------     ------ ----
D             1/1/2015 12:00:00 AM          0 /rdir/rSubDir
```