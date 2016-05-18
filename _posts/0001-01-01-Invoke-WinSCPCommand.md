---
layout: post
title: "Invoke-WinSCPCommand"
synopsis: "Invokes a command on an Active WinSCP Session."
---

---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Invoke-WinSCPCommand [-WinSCPSession] <Session> [-Command] <String[]> [<CommonParameters>]
```

---

#### **Description**

Invokes a command against the remote system hosting the FTP/SFTP Service.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
* Accept Wildcard Characters: False

[Command \<String\[\]\>](http://winscp.net/eng/docs/library_commandexecutionresult)

Command to execute.

* Required: True
* Position: 1
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

[WinSCP.CommandExecutionResult](http://winscp.net/eng/docs/library_commandexecutionresult)

* Represents results of Session.ExecuteCommand.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.

---

#### **Example 1**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Invoke-WinSCPCommand -WinSCPSession $session -Command ("mysqldump --opt -u {0} --password={1} --all-databases | gzip > {2}" -f $dbUsername, $dbPassword, $tempFilePath)
```