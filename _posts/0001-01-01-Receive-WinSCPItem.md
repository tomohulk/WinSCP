---
layout: post
title: "Receive-WinSCPItem"
synopsis: "Receives objects from an active WinSCP Session."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Receive-WinSCPItem [-WinSCPSession] <Session> [-Path] <String[]> [[-Destination] <String>] [-Remove] [[-TransferOptions] <TransferOptions>] [<CommonParameters>]
```

---

#### **Description**

After creating a valid WinSCP Session, this function can be used to receive objects and remove them from the remote source if desired.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
* Accept Wildcard Characters: False

[Path \<String\[\]\>](http://winscp.net/eng/docs/library_session_getfiles)

Full path to remote directory followed by slash and wildcard to select files or subdirectories to download. When wildcard is omitted (path ends with slash), all files and subdirectories in the remote directory are downloaded.

* Required: True
* Position: 1
* Default Value: 
* Accept Pipeline Input: True (ByPropertyName)
* Accept Wildcard Characters: True

[Destination \<String\>](http://winscp.net/eng/docs/library_session_getfiles)

Full path to download the file to. When downloading multiple files, the filename in the path should be replaced with operation mask or omitted (path ends with slash).

* Required: False
* Position: 2
* Default Value: $pwd (Primary Working Directory)
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

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
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Receive-WinSCPItem -Path '/rDir/rFile.txt' -Destination 'C:\lDir\lFile.txt'

Transfers         Failures IsSuccess
---------         -------- ---------
{/rDir/rFile.txt} {}       True
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Receive-WinSCPItem -WinSCPSession $session -Path '/rDir/rFile.txt' -Destination 'C:\lDir\lFile.txt' -Remove

Transfers         Failures IsSuccess
---------         -------- ---------
{/rDir/rFile.txt} {}       True
```