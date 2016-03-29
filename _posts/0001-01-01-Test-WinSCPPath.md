---
layout: post
title: "Test-WinSCPPath"
synopsis: "Test if a remote object exists."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Test-WinSCPPath [-WinSCPSession] <Session> [-Path] <String[]> [<CommonParameters>]
```

---

#### **Description**

After creating a valid WinSCP Session, this function can be used to test if a directory or file exists on the remote source.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
* Accept Wildcard Characters: False

[Path \<String\[\]\>](http://winscp.net/eng/docs/library_session_fileexists)

Full path to the remote object.

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

[System.Boolean](https://msdn.microsoft.com/en-us/library/system.boolean(v=vs.110).aspx)

* Represents a Boolean (true or false) value.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Test-WinSCPPath -Path '/rDir/rSubDir'

True
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Test-WinSCPPath -WinSCPSession $session -Path '/rDir/NoPath'

False
```