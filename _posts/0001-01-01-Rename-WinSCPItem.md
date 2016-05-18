---
layout: post
title: "Rename-WinSCPItem"
synopsis: "Renames a remote object."
---

---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Rename-WinSCPItem [-WinSCPSession] <Session> [-Path] <String> [-NewName] <String> [-PassThru] [<CommonParameters>]
```

---

#### **Description**

Renames a remote file or directory. Be sure to include the file extension when renameing a file.

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

Full path to remote object to be renamed.

* Required: True
* Position: 1
* Default Value: 
* Accept Pipeline Input: True (ByPropertyName)
* Accept Wildcard Characters: True

[NewName \<String\>](http://winscp.net/eng/docs/library_session_movefile)

The new name for the object.

* Required: True
* Position: 2
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[PassThru \<SwitchParameter\>](http://winscp.net/eng/docs/library_remotefileinfo)

Will return a [WinSCP.RemoteFileInfo](http://winscp.net/eng/docs/library_remotefileinfo) object representation of the renamed object if used.

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
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Rename-WinSCPItem -Path '/rDir/rFile.txt' -NewName 'rNewFile.txt'
```

#### **Example 1**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Rename-WinSCPItem -WinSCPSession $session -Path '/rDir/rFile.txt' -Destination 'rNewFile.txt' -PassThru

   Directory: /rDir

FileType             LastWriteTime     Length Name
--------             -------------     ------ ----
D             1/1/2015 12:00:00 AM          0 /rNewFile.txt
```