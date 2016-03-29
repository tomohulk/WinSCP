---
layout: post
title: "New-WinSCPItem"
synopsis: "Creates a new object in an active WinSCP Session."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
New-WinSCPItem [-WinSCPSession] <Session> [[-Path] <String[]>] [[-Name] <String>] [[-ItemType] <String>] [[-Value] <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

---

#### **Description**

After establishing a valid WinSCP Session, this function can be used to create a new object on the remote host.

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

[Name \<String\>](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

The name of the new item to be created. This can be omitted if full path is used to the new item.

* Required: False
* Position: 2
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[ItemType \<String\>](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

The type of object to be created, IE: File, Directory.

* Required: False
* Position: 3
* Default Value: File
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Value \<String\>](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

Initial value to add to the object being created.

* Required: False
* Position: 4
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Force \<SwitchParameter\>](https://msdn.microsoft.com/en-us/library/system.management.automation.switchparameter(v=vs.85).aspx)

Will overwrite and existing item of the same name.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[CommonParameters \<CommonParameters\>](http://go.microsoft.com/fwlink/?LinkID=113216)

This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.

---

#### **Inputs**

[WinSCP.Session](http://winscp.net/eng/docs/library_session)

* Represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

[System.String](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

* Represents text as a series of Unicode characters.

---

#### **Outputs**

[WinSCP.RemoteFileInfo](http://winscp.net/eng/docs/library_remotefileinfo)

* Represents data about remote file.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem-Path '/rDir/rSubDir' -ItemType Directory

   Directory: /rDir/

FileType             LastWriteTime     Length Name
--------             -------------     ------ ----
D             1/1/2015 12:00:00 AM          0 /rSubDir
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> New-WinSCPItem -WinSCPSession $session -Path './rDir' -Name 'rTextFile.txt' -ItemType File -Value 'Hello World!'
   
   Directory: /rDir

FileType             LastWriteTime     Length Name
--------             -------------     ------ ----
-             1/1/2015 12:00:00 AM         12 /rTextFile.txt
```