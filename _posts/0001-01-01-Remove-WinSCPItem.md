---
layout: post
title: "Remove-WinSCPItem"
synopsis: "Removes an object from an active WinSCP Session."
---

---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Remove-WinSCPItem [-WinSCPSession] <Session> [-Path] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

---

#### **Description**

Removes an object from a remote host. This action will recurse if a the Path value is a directory.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
* Accept Wildcard Characters: False

[Path \<String\[\]\>](http://winscp.net/eng/docs/library_session_removefiles)

Full path to remote directory followed by slash and wildcard to select files or subdirectories to remove.

* Required: True
* Position: 1
* Default Value: 
* Accept Pipeline Input: True (ByPropertyName)
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

#### **Outputs**

[System.Void](https://msdn.microsoft.com/en-us/library/system.void(v=vs.110).aspx)

* Specifies a return value type for a method that does not return a value.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Remove-WinSCPItem -Path "/rDir/rFile.txt"
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Remove-WinSCPItem -WinSCPSession $session -Path "/rDir/rFile.txt"
```