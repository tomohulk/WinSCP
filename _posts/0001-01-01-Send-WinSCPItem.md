---
layout: post
title: "Send-WinSCPItem"
synopsis: "Send objects to an active WinSCP Session."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Send-WinSCPItem [-WinSCPSession] <Session> [-Path] <String[]> [[-Destination] <String>] [-Remove] [[-TransferOptions] <TransferOptions>] [<CommonParameters>]
```

---

#### **Description**

After creating a valid WinSCP Session, this function can be used to send files or folders to the remote host, as well as delete the source files after completion.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
* Accept Wildcard Characters: False

[Path \<String\[\]\>](http://winscp.net/eng/docs/library_session_putfiles)

Specifies a path to one or more locations on the local host.

* Required: True
* Position: 1
* Default Value: 
* Accept Pipeline Input: True (ByPropertyName)
* Accept Wildcard Characters: True

[Destination \<String\>](http://winscp.net/eng/docs/library_session_putfiles)

Full path to upload the file to. When uploading multiple files, the filename in the path should be replaced with ConvertTo-WinSCPEscapedString or omitted (path ends with slash).

* Required: False
* Position: 2
* Default Value: /
* Accept Pipeline Input: False
* Accept Wildcard Characters: True

[Remove \<SwitchParameter\>](http://winscp.net/eng/docs/library_session_putfiles)

When present, deletes source file(s) after transfer.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[TransferOptions \<WinSCP.TransferOptions\>](http://winscp.net/eng/docs/library_transferoptions)

Defines options for file transfers.

* Required: False
* Position: 3
* Default Value: New-Object -TypeName WinSCP.TransferOptions
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

[WinSCP.TransferOperationResult](http://winscp.net/eng/docs/library_transferoperationresult)

* Represents results of transfer operation.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Send-WinSCPItem -Path 'C:\lDir\lFile.txt' -Destination '/rDir/rFile.txt'

Transfers           Failures IsSuccess
---------           -------- ---------
{C:\lDir\lFile.txt} {}       True
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Send-WinSCPItem -WinSCPSession $session -Path 'C:\lDir\lFile.txt' -Destination '/rDir/rFile.txt' -Remove

Transfers           Failures IsSuccess
---------           -------- ---------
{C:\lDir\lFile.txt} {}       True
```