---
layout: post
title: "Remove-WinSCPSession"
synopsis: "Closes and disposes a WinSCP Session Object."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Remove-WinSCPSession [-WinSCPSession] <Session> [<CommonParameters>]
```

---

#### **Description**

After a WinSCP Session is no longer needed this function will close the connection and dispose the COM object.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
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

None.

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Remove-WinSCPSession
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME-SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Remove-WinSCPSession -WinSCPSession $session
```