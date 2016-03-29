---
layout: post
title: "Move-WinSCPItem"
synopsis: "Moves an object from one location to another from an active WinSCP Session."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Move-WinSCPItem [-WinSCPSession] <Session> [-Path] <String[]> [[-Destination] <String>] [-Force] [-PassThru] [<CommonParameters>]
```

---

#### **Description**

Once connected to an active WinSCP Session, one or many objects can be moved to another location within the same WinSCP Session.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
* Accept Wildcard Characters: False

[Path \<String\[\]\>](http://winscp.net/eng/docs/library_session_movefile)

Full path to remote item to be moved.

* Required: True
* Position: 1
* Default Value:
* Accept Pipeline Input: True (ByPropertyName)
* Accept Wildcard Characters: True

[Destination \<String\>](http://winscp.net/eng/docs/library_session_movefile)

Full path to new location to move the item to.

* Required: False
* Position: False
* Default Value: /
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Force \<SwitchParameter\>](https://msdn.microsoft.com/en-us/library/system.management.automation.switchparameter(v=vs.85).aspx)

Creates the destination directory if it does not exist.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[PassThru \<SwitchParameter\>](https://msdn.microsoft.com/en-us/library/system.management.automation.switchparameter(v=vs.85).aspx)

Returns a [WinSCP.RemoteFileInfo](http://winscp.net/eng/docs/library_remotefileinfo) of the moved object.

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

[System.Void](https://msdn.microsoft.com/en-us/library/system.void(v=vs.110).aspx)

* Specifies a return value type for a method that does not return a value.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Move-WinSCPItem -Path '/rDir/rFile.txt' -Destination '/rDir/rSubDir/'

   Directory: /rdir/rSubdir

FileType             LastWriteTime     Length Name
--------             -------------     ------ ----
D             1/1/2015 12:00:00 AM          0 rFile.txt
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Move-WinSCPItem -WinSCPSession $session -Path '/rDir/rFile.txt' -Destination '/rDir/rSubDir/' -PassThru

   Directory: /rdir/rSubdir

FileType             LastWriteTime     Length Name
--------             -------------     ------ ----
D             1/1/2015 12:00:00 AM          0 rFile.txt
```